//
//  GDDAppDelegate.m
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDAppDelegate.h"
#import "GDDMenuRootController_ipad.h"
#import "GDDRootViewController.h"
#import "UIImageView+MKNetworkKitAdditions.h"

@interface GDDAppDelegate ()
@property (nonatomic, strong, readwrite) PSStackedViewController *stackController;
@property (nonatomic, strong, readwrite) GDDFlickrEngine *flickrEngine;
@property (nonatomic, strong, readwrite) GDDEngine *downloadEngine;
@end

@implementation GDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; {
  
  [super application:application didFinishLaunchingWithOptions:launchOptions];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.clipsToBounds =YES;
    self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
  }
  // set root controller as stack controller
  GDDMenuRootController_ipad *menuController = [[GDDMenuRootController_ipad alloc] initWithNibName:@"GDDMenuRootController_ipad" bundle:nil];
  self.stackController = [[PSStackedViewController alloc] initWithRootViewController:menuController];
  
  self.stackController.largeLeftInset = 180;
  self.stackController.leftInset = 60;
  self.stackController.enableBounces = NO;
  self.stackController.enableShadows = YES;
  self.stackController.defaultShadowWidth = 10.0f;

  self.window.rootViewController = self.stackController;
  [self.window makeKeyAndVisible];
  self.flickrEngine = [[GDDFlickrEngine alloc] initWithHostName:GDDConfigPlist(@"drive_service")];
  [self.flickrEngine useCache];
  [UIImageView setDefaultEngine:self.flickrEngine];
  
  self.downloadEngine = [[GDDEngine alloc] initWithHostName:GDDConfigPlist(@"drive_service")];
  return YES;
}

@end
