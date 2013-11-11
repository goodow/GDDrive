//
//  GDDAppDelegate.h
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDRAppDelegate.h"
#import "PSStackedView.h"

#define GDDRiveDelegate ((GDDAppDelegate *)[[UIApplication sharedApplication] delegate])

@class PSStackedViewController;
@interface GDDAppDelegate : GDRAppDelegate

@property (nonatomic, strong, readonly) PSStackedViewController *stackController;

@end
