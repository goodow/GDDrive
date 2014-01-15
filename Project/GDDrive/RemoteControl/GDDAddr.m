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

static NSString *const ADDR_TOPIC = @"drive.topic";
static NSString *const ADDR_FILE = @"drive.file";



@implementation GDDAddr
+(NSString *)TOPIC:(GDDAddressStyle)style{
  return [self address:ADDR_TOPIC addressStyle:style];
}

+(NSString *)FILE:(GDDAddressStyle)style{
  return [self address:ADDR_FILE addressStyle:style];
}

#pragma mark - 公共方法
+(NSString *)concat:(NSString *)pro{
  return [NSString stringWithFormat:@"%@.%@",[GDDBusProvider equipmentID],pro];
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
  switch (style) {
    case GDDAddrReceive:
      return SID_ADDR;
    case GDDAddrSendLocal:
      return [NSString stringWithFormat:@"%@%@",[GDCBus LOCAL],SID_ADDR];
    case GDDAddrSendRemote:
      NSAssert(NO, @"本地协议，不允许发送远程协议");
      return nil;
    default:
      break;
  }
}
@end

