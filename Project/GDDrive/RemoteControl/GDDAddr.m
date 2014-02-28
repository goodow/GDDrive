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

@implementation GDDAddr

+(NSString *)addressProtocol:(NSString *)protocol addressStyle:(GDDAddressStyle)style{
  return [self address:protocol addressStyle:style];
}
#pragma mark - 公共方法
/*description 拼接设备号和请求地址。
 *parameter   pro 接口名
 *return      真实设备接口访问地址
 */
+(NSString *)concat:(NSString *)pro{
  return [NSString stringWithFormat:@"%@.%@",[GDDAddr equipmentID],pro];
}

+(NSString *)address:(NSString *)addr addressStyle:(GDDAddressStyle)style{
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

+(NSString *)localAddressProtocol:(NSString *)protocol addressStyle:(GDDAddressStyle)style{
  return [GDDAddr SWITCH_ADDR:protocol GDDAddressStyle:style];
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
  [[GDDBusProvider BUS] publish:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_SWITCH addressStyle:GDDAddrSendLocal] message:@{@"sid": [GDDAddr equipmentID]}];
}
+(void)readNSUserDefaults
{
  NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
  //读取NSString类型的数据
  EQUIPMENT_ID = [userDefaultes stringForKey:@"equipmentID"];
}
@end
