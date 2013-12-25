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
#import "GDDLoginViewController_ipad.h"

@interface GDDAppDelegate ()
@property (nonatomic, strong, readwrite) PSStackedViewController *stackController;
@property (nonatomic, strong, readwrite) GDDFlickrEngine *flickrEngine;
@property (nonatomic, strong, readwrite) GDDEngine *downloadEngine;
@property (nonatomic, strong, readwrite) GDDRealtimeEngine *realtimeEngine;
@property (nonatomic, strong, readwrite) GDDLoginViewController_ipad *loginViewController;
@end

@implementation GDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; {
  
  //设置状态条样式
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.clipsToBounds =YES;
    self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
  }
  //判断程序是否第一次执行
  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
  }
  else{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
  }
  
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    // 这里判断是否第一次
    [GDDPlistHelper createPlistMirror];
    
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
  
  
  [self loginAPPWithAnimated:NO];
  
  self.flickrEngine = [[GDDFlickrEngine alloc] initWithHostName:GDDConfigPlist(@"drive_service")];
  [self.flickrEngine useCache];
  [UIImageView setDefaultEngine:self.flickrEngine];
  
  self.downloadEngine = [[GDDEngine alloc] initWithHostName:GDDConfigPlist(@"drive_service")];
  self.realtimeEngine = [[GDDRealtimeEngine alloc]initWithHostName:GDDConfigPlist(@"realtime_service")];
  return YES;
}

-(void)loginAPPWithAnimated:(BOOL)annimated{
  if (!self.loginViewController) {
    self.loginViewController = [[GDDLoginViewController_ipad alloc]initWithNibName:@"GDDLoginViewController_ipad" bundle:nil];
  }
  //没有默认用户名密码的时候进行登录操作
  if ([[[GDDPlistHelper sharedInstance] objectFromPlistKey:@"userId"] isEqualToString:@""] || [[[GDDPlistHelper sharedInstance] objectFromPlistKey:@"token"] isEqualToString:@""]) {
    [self.stackController.rootViewController presentViewController:self.loginViewController animated:annimated completion:nil];
  }else{
    [self loadRealtime];
  }
//  [self.stackController.rootViewController presentViewController:self.loginViewController animated:NO completion:nil];
}

-(void)loadRealtime{
   //加载所有数据和界面
  [(GDDMenuRootController_ipad *)self.stackController.rootViewController loadRealtime];
}
@end
