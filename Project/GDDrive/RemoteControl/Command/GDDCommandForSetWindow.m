//
//  GDDCommandForSetWindow.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForSetWindow.h"
#import "AppDelegate.h"

@implementation GDDCommandForSetWindow
-(id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
  }
  return self;
}
+(id)commandForSetWindow {
  static GDDCommandForSetWindow *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

-(void)execute {
  UIApplication *application = [UIApplication sharedApplication];
  if (application.statusBarOrientation == UIInterfaceOrientationPortrait) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,20,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if (application.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if(application.statusBarOrientation == UIInterfaceOrientationLandscapeLeft ) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(20,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }else if (application.statusBarOrientation == UIInterfaceOrientationLandscapeRight){
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }
}
@end
