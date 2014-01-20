//
//  GDDAddr.h
//  GDDrive
//
//  Created by 大黄 on 14-1-15.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  GDDAddrReceive = 1,
  GDDAddrSendLocal = 2,
  GDDAddrSendRemote = 3
} GDDAddressStyle;

@interface GDDAddr : NSObject

+(NSString *)TOPIC:(GDDAddressStyle)style;
+(NSString *)FILE:(GDDAddressStyle)style;
@end

@interface GDDAddr (ios)
+(NSString *)SWITCH_DEVICE:(GDDAddressStyle)style;
+(NSString *)SWITCH_CLASS:(GDDAddressStyle)style;
@end

@interface GDDAddr (GDDEquipmend)
+ (NSString *)equipmentID;
+ (void)updateEquipmentID:(NSString *)equipmentID;
@end