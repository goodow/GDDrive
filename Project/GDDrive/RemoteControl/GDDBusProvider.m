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
  dispatch_once(&pred, ^{bus = [GDCWebSocketBusClient create:@"ws://data.goodow.com:8080/eventbus/websocket" options:@{@"forkLocal":@YES}];});
  return bus;
}

+(void)load{
  BUS = [GDCWebSocketBusClient create:@"ws://data.goodow.com:8080/eventbus/websocket" options:@{@"forkLocal":@YES}];
}

+(id<GDCBus>)BUS{
  return BUS;
}
@end



@implementation GDDBusProvider (Constant)
static NSString * SID_ADDR = @"@drive.equipmentID";
+ (NSString *)SID_ADDR {
  return SID_ADDR;
}
@end

@implementation GDDBusProvider (Equipmend)
static NSString *EQUIPMENT_ID;
+ (NSString *)equipmentID{
  [GDDBusProvider readNSUserDefaults];
  return EQUIPMENT_ID;
}
+ (void)updateEquipmentID:(NSString *)equipmentID{
  EQUIPMENT_ID = equipmentID;
  [GDDBusProvider saveNSUserDefaults];
}

+(void)saveNSUserDefaults
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:EQUIPMENT_ID forKey:@"equipmentID"];
  [userDefaults synchronize];
  //同步完成后发送消息 通知所有注册 GDD_BUS_EQUIPMENT_ID 设备id变更
  [[GDDBusProvider BUS] publish:[NSString stringWithFormat:@"@%@",[GDDBusProvider SID_ADDR]] message:@{@"sid": [GDDBusProvider equipmentID]}];
}
+(void)readNSUserDefaults
{
  NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
  //读取NSString类型的数据
  EQUIPMENT_ID = [userDefaultes stringForKey:@"equipmentID"];
}
+(NSString *)concat:(NSString *)pro{
  return [NSString stringWithFormat:@"%@.%@",EQUIPMENT_ID,pro];
}

@end