//
//  CommandInvokerSingleton.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandInvokerSingleton.h"
#import "GDDCommand.h"

@implementation GDDCommandInvokerSingleton

#pragma mark -
#pragma mark 单例方法群
// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
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

+ (GDDCommandInvokerSingleton *) sharedInstance {
  static GDDCommandInvokerSingleton *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}


#pragma mark -
#pragma mark 运行一个命令对象
-(void)runCommandWithCommandObject:(id)commandObject {
  if ([commandObject conformsToProtocol:@protocol(GDDCommand)]) {
    [commandObject execute];
  }
}

@end