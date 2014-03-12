//
//  GDDCommandForNetworkState.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForNetworkState.h"
#import "GDDBusProvider.h"
#import "MRProgressOverlayView.h"
#import "AppDelegate.h"

@implementation GDDCommandForNetworkState
-(id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
  }
  return self;
}
+(id)commandForNetworkState {
  static GDDCommandForNetworkState *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

-(void)execute {
  GDCStateEnum *stateEnum = [[GDDBusProvider sharedInstance] getReadyState];
  switch ([stateEnum ordinal]) {
    case GDCState_CONNECTING:
    case GDCState_CLOSED:
    case GDCState_CLOSING:
      NSLog(@"CONNECTING or CLOSING or CLOSED");
      [MRProgressOverlayView showOverlayAddedTo:GDDRemoteControlDelegate.window animated:YES];
      break;
    case GDCState_OPEN:
      NSLog(@"OPEN");
      break;
    default:
      break;
  }
}
@end
