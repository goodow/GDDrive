//
//  AppDelegate.m
//  GDRemoteControl
//
//  Created by 大黄 on 13-12-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "AppDelegate.h"
#import "PSStackedViewControllerDecorate.h"
#import "GDDMenuRootController.h"
#import "GDDCommandInvokerSingleton.h"
#import "GDDCommandForSetWindow.h"
#import "GDDCommandForNetwork.h"
#import "GDDCommandForFirstStart.h"
#import "GDDCommandForNetworkState.h"

@interface AppDelegate ()
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  id command = nil;
  //设置windows
  command = [GDDCommandForSetWindow commandForSetWindow];
  [[GDDCommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];

  //监听网路状态
  command = [GDDCommandForNetwork commandForNetwork];
  [[GDDCommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];

  //判断程序是否第一次执行
  command = [GDDCommandForFirstStart commandForFirstStart];
  [[GDDCommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];

  //网络状态
  command = [GDDCommandForNetworkState commandForNetworkState];
  [[GDDCommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];

  GDDMenuRootController *menuController = [[GDDMenuRootController alloc] initWithNibName:@"GDDMenuRootController" bundle:nil];
  PSStackedViewControllerDecorate *stackController = [[PSStackedViewControllerDecorate alloc] initWithRootViewController:menuController];
  stackController.largeLeftInset = 180;
  stackController.leftInset = 60;
  stackController.enableBounces = NO;
  stackController.enableShadows = YES;
  stackController.defaultShadowWidth = 10.0f;
  menuController.stackedViewControllerDecorate = stackController;
  self.window.rootViewController = stackController;
  [self.window makeKeyAndVisible];
  
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