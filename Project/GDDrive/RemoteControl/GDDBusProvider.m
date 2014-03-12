//
//  GDDBus.m
//  GDDrive
//
//  Created by 大黄 on 13-12-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDBusProvider.h"
#import "GDDAddr.h"

@interface GDDBusProvider ()
@end

@implementation GDDBusProvider

+ (id<GDCBus>)BUS{
  return [GDDBusProvider sharedInstance];
}

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

+ (id<GDCBus>) sharedInstance {
  static id<GDCBus> singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[GDCReconnectBusClient alloc] initWithUrl:@"ws://data.goodow.com:8080/eventbus/websocket" options:@{[GDCSimpleBus MODE_MIX]:@YES}];});
  return singletonInstance;
}


@end

