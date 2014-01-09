//
//  PSStackedViewControllerDecorate.m
//  GDDrive
//
//  Created by 大黄 on 14-1-8.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "PSStackedViewControllerDecorate.h"
#import "AppDelegate.h"

@interface PSStackedViewControllerDecorate ()

@end

@implementation PSStackedViewControllerDecorate

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
  return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
  return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration; {
  if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,20,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(20,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }
}


@end
