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

static NSString *const ADDR_TOPIC = @"drive.topic";//主题界面呈现
static NSString *const ADDR_ACTIVITY = @"drive.activity";//活动界面呈现
static NSString *const ADDR_SETTINGS_RESOLUTION = @"drive.view.resolution"; //分辨率输出
static NSString *const ADDR_SETTINGS_LOCATION = @"drive.settings.location"; //请求设备的位置信息
static NSString *const ADDR_SETTINGS_INFORMATION = @"drive.settings.information"; //请求设备的信息
static NSString *const ADDR_SETTINGS_CONNECTIVITY = @"drive.connectivity"; //请求设备网络信息
static NSString *const ADDR_INPUT_SIMULATE_KEYBOARD = @"drive.input"; //键盘鼠标信号模拟
static NSString *const ADDR_NOTIFICATION = @"drive.notification"; //信息通知
static NSString *const ADDR_ATTACHMEND_SEARCH = @"drive.attachment.search"; //附件搜索
static NSString *const ADDR_TAG_CHILDREN = @"drive.tag.children"; //查询同时属于多个标签的子标签
static NSString *const ADDR_VIEW = @"drive.view"; //界面跳转 包括[home,repository,favorite,settings,settings.wifi,settings.screenOffset,aboutUs]这些界面 将由此接口代替
static NSString *const ADDR_FAVORITES_SEARCH = @"drive.star.search"; //查询收藏列表
	static NSString *const ADDR_EDITED_LIST = @"drive.star"; //查询 添加 删除列表

static NSString *const GDD_LOCAL_ADDR_SWITCH = @"@drive.control.switch";
static NSString *const GDD_LOCAL_ADDR_CLASS = @"@drive.control.class";
static NSString *const GDD_LOCAL_ADDR_SETTINGS = @"@drive.control.settings";
static NSString *const GDD_LOCAL_ADDR_SETTINGS_ABOOUT_US = @"@drive.control.settings.aboutUs";
static NSString *const GDD_LOCAL_ADDR_SETTINGS_LOCATION = @"@drive.control.settings.location";
static NSString *const GDD_LOCAL_ADDR_SETTINGS_INFORMATION = @"@drive.control.settings.information";
static NSString *const GDD_LOCAL_ADDR_TOPIC_ACTIVITY = @"@drive.topic.activity";
static NSString *const GDD_LOCAL_ADDR_ACTIVITY_DATA = @"@drive.topic.activity.data";
static NSString *const GDD_LOCAL_ADDR_FAVORITE = @"@drive.topic.favorite";
static NSString *const GDD_LOCAL_ADDR_DELETE_FAVORITE_LIST = @"@drive.star.favorite.delete";

@interface GDDAddr : NSObject
+(NSString *)addressProtocol:(NSString *)protocol addressStyle:(GDDAddressStyle)style;
@end

@interface GDDAddr (ios)
+(NSString *)localAddressProtocol:(NSString *)protocol addressStyle:(GDDAddressStyle)style;
@end

@interface GDDAddr (GDDEquipmend)
+ (NSString *)equipmentID;
+ (void)updateEquipmentID:(NSString *)equipmentID;
@end
