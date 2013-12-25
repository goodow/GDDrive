//
//  GDDDescriptionMessageViewController.m
//  GDDrive
//
//  Created by 大黄 on 13-11-12.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "GDDDescriptionMessageViewController_ipad.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "GDDGenreDictionary.h"
#import "Boolean.h"
#import "GDDOffineFilesHelper.h"

@interface GDDDescriptionMessageViewController_ipad ()
@property (nonatomic, weak) IBOutlet UIView *mainMessageView;
@property (nonatomic, weak) IBOutlet UIView *messageView;
@property (nonatomic, weak) IBOutlet UIView *offlineView;
@property (nonatomic, weak) IBOutlet UISwitch *offlineSwitch;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *fileOrfolderNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fileOrfolderTypeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *fileOrfolderImageView;

-(IBAction)dismissViewListener:(id)sender;
-(IBAction)switchListener:(id)sender;
-(IBAction)openMultimediaListener:(id)sender;
@end

@implementation GDDDescriptionMessageViewController_ipad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.mainMessageView.layer setBorderWidth:1.0f];
  [self.mainMessageView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
  [self.mainMessageView.layer setShadowOffset:CGSizeMake(-1, 0)];
  [self.mainMessageView.layer setShadowOpacity:0.4f];
  [self.mainMessageView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];
  
  [self.messageView.layer setBorderWidth:1.0f];
  [self.messageView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
  [self.messageView.layer setShadowOffset:CGSizeMake(-1, 1)];
  [self.messageView.layer setShadowOpacity:0.2f];
  [self.messageView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];
  
  [self.offlineView.layer setBorderWidth:1.0f];
  [self.offlineView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
  [self.offlineView.layer setShadowOffset:CGSizeMake(-1, 1)];
  [self.offlineView.layer setShadowOpacity:0.2f];
  [self.offlineView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];//  [self presentViewController];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)presentViewControllerCompletion:(CompletionBlock)completion{
  [GDDRiveDelegate.window addSubview:self.view];
  CGRect rect = [[UIScreen mainScreen] bounds];
  self.view.center = CGPointMake(rect.size.width, rect.size.height/2);
  self.view.alpha = 0.0f;
  [UIView animateWithDuration:0.3f animations:^{
    self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    self.view.alpha = 1.0f;
  } completion:^(BOOL finished) {
    completion(finished);
  }];
}
-(void)dismissViewControllerCompletion:(CompletionBlock)completion{
  //删除前要cancal所有网络资源
  [self.thumbnailImageView cancelOperation];
  CGRect rect = [[UIScreen mainScreen] bounds];
  self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
  self.view.alpha = 1.0f;
  [UIView animateWithDuration:0.3f animations:^{
    self.view.center = CGPointMake(rect.size.width, rect.size.height/2);
    self.view.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [self.view removeFromSuperview];
    if (completion) completion(finished);
  }];
}

#pragma mark - IBAction
-(IBAction)dismissViewListener:(id)sender{
  [self dismissViewControllerCompletion:nil];
}
-(IBAction)openMultimediaListener:(id)sender{
  NSLog(@"openMultimediaListener");
}
-(IBAction)switchListener:(id)sender {

}
@end
