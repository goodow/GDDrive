//
//  AppDelegate.m
//  GDRemoteControl
//
//  Created by 大黄 on 13-12-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "AppDelegate.h"
#import "GDDMenuRootController.h"
#import "GDDRootViewController.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "GDDLoginViewController_ipad.h"
#import "GDDBusProvider.h"

@interface AppDelegate ()
@property (nonatomic, strong) GDCMessageBlock handlerBlock;
@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, strong, readwrite) GDDLoginViewController_ipad *loginViewController;
@property (nonatomic, strong, readwrite) PSStackedViewControllerDecorate *stackController;
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  if (application.statusBarOrientation == UIInterfaceOrientationPortrait) {
    self.window.clipsToBounds =YES;
    self.window.frame =  CGRectMake(0,20,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if (application.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    self.window.clipsToBounds =YES;
    self.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if(application.statusBarOrientation == UIInterfaceOrientationLandscapeLeft ) {
    self.window.clipsToBounds =YES;
    self.window.frame =  CGRectMake(20,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }else if (application.statusBarOrientation == UIInterfaceOrientationLandscapeRight){
    self.window.clipsToBounds =YES;
    self.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }
  self.bus = [GDDBusProvider BUS];
  GDCStateEnum *stateEnum = [self.bus getReadyState];
  
  switch ([stateEnum ordinal]) {
    case GDCState_CONNECTING:
    case GDCState_CLOSED:
    case GDCState_CLOSING:
      NSLog(@"CONNECTING or CLOSING or CLOSED");
      [MRProgressOverlayView showOverlayAddedTo:self.window animated:YES];
      break;
    case GDCState_OPEN:
      NSLog(@"OPEN");
      break;
    default:
      break;
  }
  
  [self.bus registerHandler:[GDCBus LOCAL_ON_CLOSE] handler:^(id<GDCMessage> message) {
    //进入模态并提示网络失败
    NSLog(@"网络连接失败");
    [MRProgressOverlayView showOverlayAddedTo:self.window animated:YES];
  }];
  [self.bus registerHandler:[GDCBus LOCAL_ON_OPEN] handler:^(id<GDCMessage> message) {
    //进入模态并提示网络失败
    NSLog(@"网络连接成功");
    [MRProgressOverlayView dismissOverlayForView:self.window animated:YES];
  }];
  
  
  //判断程序是否第一次执行
  //  [application setStatusBarStyle:UIStatusBarStyleLightContent];
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
  
  GDDMenuRootController *menuController = [[GDDMenuRootController alloc] initWithNibName:@"GDDMenuRootController" bundle:nil];
  self.stackController = [[PSStackedViewControllerDecorate alloc] initWithRootViewController:menuController];
  
  self.stackController.largeLeftInset = 180;
  self.stackController.leftInset = 60;
  self.stackController.enableBounces = NO;
  self.stackController.enableShadows = YES;
  self.stackController.defaultShadowWidth = 10.0f;
  self.window.rootViewController = self.stackController;
  [self.window makeKeyAndVisible];
  
  
  [(GDDMenuRootController *)self.stackController.rootViewController loadRealtime];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  return UIInterfaceOrientationMaskAll;
}

@end

@interface UINavigationController (StatusBarSet)

- (UIStatusBarStyle)preferredStatusBarStyle;

@end

@implementation UINavigationController (StatusBarSet)

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return self.topViewController.preferredStatusBarStyle;
}

@end