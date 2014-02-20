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
+(NSString *)SETTINGS:(GDDAddressStyle)style;
+(NSString *)SETTINGS_WIFI:(GDDAddressStyle)style;
+(NSString *)SETTINGS_RESOLUTION:(GDDAddressStyle)style;
+(NSString *)SETTINGS_SCREEN_OFFSET:(GDDAddressStyle)style;
+(NSString *)SETTINGS_ABOOUT_US:(GDDAddressStyle)style;
+(NSString *)SETTINGS_LOCATION:(GDDAddressStyle)style;
+(NSString *)SETTINGS_INFORMATION:(GDDAddressStyle)style;
+(NSString *)SETTINGS_CONNECTIVITY:(GDDAddressStyle)style;
+(NSString *)INPUT_SIMULATE_KEYBOARD:(GDDAddressStyle)style;
+(NSString *)NOTIFICATION:(GDDAddressStyle)style;
@end

@interface GDDAddr (ios)
+(NSString *)SWITCH_DEVICE:(GDDAddressStyle)style;
+(NSString *)SWITCH_CLASS:(GDDAddressStyle)style;
+(NSString *)SWITCH_SETTINGS:(GDDAddressStyle)style;
+(NSString *)SWITCH_SETTINGS_ABOOUT_US:(GDDAddressStyle)style;
+(NSString *)SWITCH_SETTINGS_LOCATION:(GDDAddressStyle)style;
+(NSString *)SWITCH_SETTINGS_INFORMATION:(GDDAddressStyle)style;
@end

@interface GDDAddr (GDDEquipmend)
+ (NSString *)equipmentID;
+ (void)updateEquipmentID:(NSString *)equipmentID;
@end