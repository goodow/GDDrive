//
//  GDDBus.m
//  GDDrive
//
//  Created by 大黄 on 13-12-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDBus.h"

@interface GDDBus ()
@property (nonatomic, strong) id <GDCBus> bus;
@end

@implementation GDDBus
+ (id) sharedInstance; {
  static GDDBus *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}
+(void)load{
  
}
+(void)initialize{
  
}
-(id)init{
  if (self = [super init]) {
    RNAssert(NO, @"GDDPlistHelper 为单例不能直接创建");
  }
  return self;
}
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    
    self.bus = [GDCWebSocketBusClient create:@"ws://data.goodow.com:8080/eventbus/websocket" options:nil];
  }
  return self;
}
-(id<GDCBus>)bus{
  return _bus;
}
@end
