//
//  AppDelegate.h
//  GDRemoteControl
//
//  Created by 大黄 on 13-12-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSStackedViewControllerDecorate.h"


#define GDDRemoteControlDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) PSStackedViewControllerDecorate *stackController;
@end
