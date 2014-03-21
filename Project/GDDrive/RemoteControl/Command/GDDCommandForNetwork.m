//
//  CommandForNetwork.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForNetwork.h"
#import "GDDBusProvider.h"
#import "MRProgressOverlayView.h"
#import "AppDelegate.h"

@implementation GDDCommandForNetwork
-(void)execute {
  [[GDDBusProvider sharedInstance] registerHandler:[GDCBus LOCAL_ON_CLOSE] handler:^(id<GDCMessage> message) {
    //进入模态并提示网络失败
    NSLog(@"网络连接失败");
    [MRProgressOverlayView showOverlayAddedTo:GDDRemoteControlDelegate.window animated:YES];
  }];
  [[GDDBusProvider sharedInstance] registerHandler:[GDCBus LOCAL_ON_OPEN] handler:^(id<GDCMessage> message) {
    //进入模态并提示网络失败
    NSLog(@"网络连接成功");
    [MRProgressOverlayView dismissOverlayForView:GDDRemoteControlDelegate.window animated:YES];
  }];
}
@end
