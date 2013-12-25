//
//  AppDelegate.m
//  GDRemoteControl
//
//  Created by 大黄 on 13-12-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "AppDelegate.h"
#import "GDDMenuRootController_ipad.h"
#import "GDDRootViewController.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "GDDLoginViewController_ipad.h"
#import "GDDRemoteControlViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong, readwrite) GDDFlickrEngine *flickrEngine;
@property (nonatomic, strong, readwrite) GDDEngine *downloadEngine;
@property (nonatomic, strong, readwrite) GDDRealtimeEngine *realtimeEngine;
@property (nonatomic, strong, readwrite) GDDLoginViewController_ipad *loginViewController;
@property (nonatomic, strong) GDDRemoteControlViewController *remoteControlViewController;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
  
  self.remoteControlViewController = [[GDDRemoteControlViewController alloc]initWithNibName:@"GDDRemoteControlViewController" bundle:nil];
  self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:self.remoteControlViewController];
  [self.window makeKeyAndVisible];
  
  
  
//  self.flickrEngine = [[GDDFlickrEngine alloc] initWithHostName:GDDConfigPlist(@"drive_service")];
//  [self.flickrEngine useCache];
//  [UIImageView setDefaultEngine:self.flickrEngine];
//  
//  self.downloadEngine = [[GDDEngine alloc] initWithHostName:GDDConfigPlist(@"drive_service")];
//  self.realtimeEngine = [[GDDRealtimeEngine alloc]initWithHostName:GDDConfigPlist(@"realtime_service")];
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
@end
