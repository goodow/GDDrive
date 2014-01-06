//
//  GDDBus.m
//  GDDrive
//
//  Created by 大黄 on 13-12-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDBusProvider.h"

@interface GDDBusProvider ()
@end

@implementation GDDBusProvider

static id<GDCBus> BUS;

+(id<GDCBus>)bus{
  static id <GDCBus> bus;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{bus =  [GDCWebSocketBusClient create:@"ws://data.goodow.com:8080/eventbus/websocket" options:nil];});
  return bus;
}

+(void)load{
  BUS =  [GDCWebSocketBusClient create:@"ws://data.goodow.com:8080/eventbus/websocket" options:nil];
}
+(void)initialize{
  if(self == [GDDBusProvider class]) {
    
  }
}
+(id<GDCBus>)BUS{
  return BUS;
}
@end
