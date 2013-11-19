//
//  GDDDescriptionMessageViewController.m
//  GDDrive
//
//  Created by 大黄 on 13-11-12.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h> 
#import "GDDDescriptionMessageViewController_ipad.h"
#import "GDDAppDelegate.h"

@interface GDDDescriptionMessageViewController_ipad ()
-(IBAction)dismissViewListener:(id)sender;
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
//  [self presentViewController];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (void)presentViewController{
  [GDDRiveDelegate.window addSubview:self.view];
  CGRect rect = [[UIScreen mainScreen] bounds];
  self.view.center = CGPointMake(rect.size.width, rect.size.height/2);
  self.view.alpha = 0.0f;
  [UIView animateWithDuration:0.2f animations:^{
    self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    self.view.alpha = 1.0f;
  } completion:^(BOOL finished) {
    
  }];
}
-(void)dismissViewController{
  CGRect rect = [[UIScreen mainScreen] bounds];
  self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
  self.view.alpha = 1.0f;
  [UIView animateWithDuration:0.2f animations:^{
    self.view.center = CGPointMake(rect.size.width, rect.size.height/2);
    self.view.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [self.view removeFromSuperview];
  }];
}
-(IBAction)dismissViewListener:(id)sender{
  [self dismissViewController];
}
@end
