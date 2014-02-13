//
//  GDDAddr.m
//  GDDrive
//
//  Created by 大黄 on 14-1-15.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDAddr.h"
#import "GDDBusProvider.h"

static NSString *const SID = @"huang.";
static NSString *const SID_ADDR = @"@drive.control.switch";
static NSString *const SID_ADDR_CLASS = @"@drive.control.class";
static NSString *const SID_ADDR_SETTINGS_WIFI = @"@drive.control.settings.wifi";
static NSString *const SID_ADDR_SETTINGS_RESOLUTION = @"@drive.control.settings.resolution";
static NSString *const SID_ADDR_SETTINGS_SCREEN_OFFSET = @"@drive.control.settings.screenOffset";
static NSString *const SID_ADDR_SETTINGS_ABOOUT_US = @"@drive.control.settings.aboutUs";


static NSString *const ADDR_TOPIC = @"drive.topic";
static NSString *const ADDR_FILE = @"drive.file";
static NSString *const ADDR_SETTINGS = @"drive.view.settings";
static NSString *const ADDR_SETTINGS_WIFI = @"drive.view.wifi";
static NSString *const ADDR_SETTINGS_RESOLUTION = @"drive.view.resolution";
static NSString *const ADDR_SETTINGS_SCREEN_OFFSET = @"drive.view.screenOffset";
static NSString *const ADDR_SETTINGS_ABOOUT_US = @"drive.view.aboutUs";



@implementation GDDAddr
+(NSString *)TOPIC:(GDDAddressStyle)style{
  return [self address:ADDR_TOPIC addressStyle:style];
}

+(NSString *)FILE:(GDDAddressStyle)style{
  return [self address:ADDR_FILE addressStyle:style];
}

+(NSString *)SETTINGS:(GDDAddressStyle)style{
  return [self address:ADDR_SETTINGS addressStyle:style];
}
+(NSString *)SETTINGS_WIFI:(GDDAddressStyle)style{
  return [self address:ADDR_SETTINGS_WIFI addressStyle:style];
}
+(NSString *)SETTINGS_RESOLUTION:(GDDAddressStyle)style{
  return [self address:ADDR_SETTINGS_RESOLUTION addressStyle:style];
}
+(NSString *)SETTINGS_SCREEN_OFFSET:(GDDAddressStyle)style{
  return [self address:ADDR_SETTINGS_SCREEN_OFFSET addressStyle:style];
}
+(NSString *)SETTINGS_ABOOUT_US:(GDDAddressStyle)style{
  return [self address:ADDR_SETTINGS_ABOOUT_US addressStyle:style];
}

#pragma mark - 公共方法
/*description 拼接设备号和请求地址。
 *parameter   pro 接口名
 *return      真实设备接口访问地址
 */
+(NSString *)concat:(NSString *)pro{
  return [NSString stringWithFormat:@"%@.%@",[GDDAddr equipmentID],pro];
}

+(NSString *)address:(NSString *) addr addressStyle:(GDDAddressStyle)style{
  switch (style)
  {
    case GDDAddrReceive:
      return [NSString stringWithFormat:@"%@%@",SID,addr];
    case GDDAddrSendLocal:
      return  [NSString stringWithFormat:@"%@%@%@",[GDCBus LOCAL],SID,addr];
    case GDDAddrSendRemote:
      return [self concat:addr];
    default:
      break;
  }
}
@end

@implementation GDDAddr (ios)
+(NSString *)SWITCH_DEVICE:(GDDAddressStyle)style{
  return [GDDAddr SWITCH_ADDR:SID_ADDR GDDAddressStyle:style];
}
+(NSString *)SWITCH_CLASS:(GDDAddressStyle)style{
  return [GDDAddr SWITCH_ADDR:SID_ADDR_CLASS GDDAddressStyle:style];
}
+(NSString *)SWITCH_SETTINGS_WIFI:(GDDAddressStyle)style{
  return [GDDAddr SWITCH_ADDR:SID_ADDR_SETTINGS_WIFI GDDAddressStyle:style];
}
+(NSString *)SWITCH_SETTINGS_RESOLUTION:(GDDAddressStyle)style{
  return [GDDAddr SWITCH_ADDR:SID_ADDR_SETTINGS_RESOLUTION GDDAddressStyle:style];
}
+(NSString *)SWITCH_SETTINGS_SCREEN_OFFSET:(GDDAddressStyle)style{
  return [GDDAddr SWITCH_ADDR:SID_ADDR_SETTINGS_SCREEN_OFFSET GDDAddressStyle:style];
}
+(NSString *)SWITCH_SETTINGS_ABOOUT_US:(GDDAddressStyle)style{
  return [GDDAddr SWITCH_ADDR:SID_ADDR_SETTINGS_ABOOUT_US GDDAddressStyle:style];
}

#pragma mark - 公共方法 (ios)
/*SWITCH_ADDR       转发地址
 *GDDAddressStyle   设置为接收者还是发送者
 *return            新可使用地址
 */
+(NSString *)SWITCH_ADDR:(NSString*)addr GDDAddressStyle:(GDDAddressStyle)style{
  switch (style) {
    case GDDAddrReceive:
      return addr;
    case GDDAddrSendLocal:
      return [NSString stringWithFormat:@"%@%@",[GDCBus LOCAL],addr];
    case GDDAddrSendRemote:
      NSAssert(NO, @"本地协议，不允许发送远程协议");
      return nil;
    default:
      break;
  }
}
@end

@implementation GDDAddr (GDDEquipmend)
static NSString *EQUIPMENT_ID;
+ (NSString *)equipmentID{
  [GDDAddr readNSUserDefaults];
  return EQUIPMENT_ID;
}
+ (void)updateEquipmentID:(NSString *)equipmentID{
  EQUIPMENT_ID = equipmentID;
  [GDDAddr saveNSUserDefaults];
}

+(void)saveNSUserDefaults
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:EQUIPMENT_ID forKey:@"equipmentID"];
  [userDefaults synchronize];
  //同步完成后发送消息 通知所有注册 GDD_BUS_EQUIPMENT_ID 设备id变更
  [[GDDBusProvider BUS] publish:[GDDAddr SWITCH_DEVICE:GDDAddrSendLocal] message:@{@"sid": [GDDAddr equipmentID]}];
}
+(void)readNSUserDefaults
{
  NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
  //读取NSString类型的数据
  EQUIPMENT_ID = [userDefaultes stringForKey:@"equipmentID"];
}
@end