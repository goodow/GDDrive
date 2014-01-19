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

static id<GDCBus> BUS;

+(id<GDCBus>)bus{
  static id <GDCBus> bus;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    bus = [[GDCWebSocketBusClient alloc] initWithUrl:@"ws://data.goodow.com:8080/eventbus/websocket" options:@{@"forkLocal":@YES}];
  });
  return bus;
}
+(void)initialize{
  if (self == [GDDBusProvider class]) {
    BUS = [[GDCWebSocketBusClient alloc] initWithUrl:@"ws://data.goodow.com:8080/eventbus/websocket" options:@{@"forkLocal":@YES}];
  }
}

+(id<GDCBus>)BUS{
  return BUS;
}
@end

