//
//  GDDLoginViewController_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-29.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDLoginViewController_ipad.h"
#import "GDDPlistHelper.h"

@interface GDDLoginViewController_ipad ()

@property (nonatomic, strong) IBOutlet UITextField *userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

-(IBAction)loginListener:(id)sender;

@end

@implementation GDDLoginViewController_ipad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.passwordTextField setSecureTextEntry:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)loginListener:(id)sender{
  
  NSString *userName = @"";
  NSString *password = @"";
  userName = self.userNameTextField.text;
  password = self.passwordTextField.text;
  
  
  [GDDRiveDelegate.realtimeEngine loginWithUserName:userName
                                           password:password
                                  completionHandler:^(NSDictionary *response) {
                                    
                                    [[GDDPlistHelper sharedInstance]setInPlistObject:[response objectForKey:@"userId"] forKey:@"userId"];
                                    [[GDDPlistHelper sharedInstance]setInPlistObject:[response objectForKey:@"token"] forKey:@"token"];
                                    [[GDDPlistHelper sharedInstance]setInPlistObject:[response objectForKey:@"name"] forKey:@"name"];
                                    [[GDDPlistHelper sharedInstance]setInPlistObject:[response objectForKey:@"displayName"] forKey:@"display_name"];
                                    
                                    [self dismissViewControllerAnimated:YES completion:^{
                                      [GDDRiveDelegate loadRealtime];
                                    }];
                                    
                                  }
                                       errorHandler:^(NSString *errorString, NSError *error) {
                                         
                                       }];  
}

@end
