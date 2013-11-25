//
//  GDDAppDelegate.h
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDRAppDelegate.h"
#import "PSStackedView.h"
#import "GDDFlickrEngine.h"
#import "GDDEngine.h"

#define GDDRiveDelegate ((GDDAppDelegate *)[[UIApplication sharedApplication] delegate])
#define GDDConfigPlist(__KEY__) [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]]objectForKey:__KEY__]
#define GDDMultimediaHeadURL(__ID__) [NSString stringWithFormat:@"http://%@/serve?id=%@", GDDConfigPlist(@"drive_service"),__ID__]

@class PSStackedViewController;
@interface GDDAppDelegate : GDRAppDelegate
@property (nonatomic, strong, readonly) PSStackedViewController *stackController;
@property (nonatomic, strong, readonly) GDDFlickrEngine *flickrEngine;
@property (nonatomic, strong, readonly) GDDEngine *downloadEngine;

@end
