//
//  CommandForNetwork.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForNetwork.h"
#import "GDDBusProvider.h"
#import "MRProgressOverlayView.h"
#import "AppDelegate.h"

@implementation GDDCommandForNetwork

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
+(id)commandForNetwork {
  static GDDCommandForNetwork *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

-(void)execute {
  [[GDDBusProvider sharedInstance] registerHandler:[GDCBus LOCAL_ON_CLOSE] handler:^(id<GDCMessage> message) {
    //进入模态并提示网络失败
    NSLog(@"网络连接失败");
    [MRProgressOverlayView showOverlayAddedTo:GDDRemoteControlDelegate.window animated:YES];
  }];
  [[GDDBusProvider sharedInstance] registerHandler:[GDCBus LOCAL_ON_OPEN] handler:^(id<GDCMessage> message) {
    //进入模态并提示网络失败
    NSLog(@"网络连接成功");
    [MRProgressOverlayView dismissOverlayForView:GDDRemoteControlDelegate.window animated:YES];
  }];
}

@end
