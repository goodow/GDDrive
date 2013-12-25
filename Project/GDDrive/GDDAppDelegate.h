//
//  GDDAppDelegate.h
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "PSStackedView.h"
#import "GDDFlickrEngine.h"
#import "GDDEngine.h"
#import "GDDRealtimeEngine.h"
#import "GDDPlistHelper.h"
#import <UIKit/UIKit.h>
#define GDDRiveDelegate ((GDDAppDelegate *)[[UIApplication sharedApplication] delegate])
//#define GDDConfigPlist(__KEY__) [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]]objectForKey:__KEY__]
#define GDDConfigPlist(__KEY__) [[GDDPlistHelper sharedInstance] objectFromPlistKey:__KEY__]
#define GDDMultimediaHeadURL(__ID__) [NSString stringWithFormat:@"http://%@/serve?id=%@", GDDConfigPlist(@"drive_service"),__ID__]
#define GDDRealtimeLoginURL(__ID__,__PS__) [NSString stringWithFormat:@"http://221.230.60.42:8080/_ah/api/account/v0.0.1/login/%@/%@",__ID__,__PS__]

@class PSStackedViewController;
@interface GDDAppDelegate :  UIResponder <UIApplicationDelegate>
@property (nonatomic, strong, readonly) PSStackedViewController *stackController;
@property (nonatomic, strong, readonly) GDDFlickrEngine *flickrEngine;
@property (nonatomic, strong, readonly) GDDEngine *downloadEngine;
@property (nonatomic, strong, readonly) GDDRealtimeEngine *realtimeEngine;


-(void)loginAPPWithAnimated:(BOOL)annimated;
-(void)loadRealtime;
@end
