//
//  GDDBus.h
//  GDDrive
//
//  Created by 大黄 on 13-12-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDChannel.h"

@interface GDDBusProvider : NSObject
+(id<GDCBus>)BUS;

@end

@interface GDDBusProvider (Equipmend)
+ (NSString *)equipmentID;
+ (void)updateEquipmentID:(NSString *)equipmentID;

/*description 拼接设备号和请求地址。
 *parameter   pro 接口名
 *return      真实设备接口访问地址
 */
+(NSString *)concat:(NSString *)pro;
@end
