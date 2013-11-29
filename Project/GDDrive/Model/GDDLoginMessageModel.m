//
//  GDDLoginMessageModel.m
//  GDDrive
//
//  Created by 大黄 on 13-12-2.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDLoginMessageModel.h"

@implementation GDDLoginMessageModel
+ (GDDLoginMessageModel *) sharedInstance {
  static GDDLoginMessageModel *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}
+(void)load{
  
}
-(id)init{
  if (self = [super init]) {
    RNAssert(NO, @"GDDPlistHelper 为单例不能直接创建");
  }
  return self;
}
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    
    
  }
  return self;
}
-(void)bindData{
  self.name = [[GDDPlistHelper sharedInstance]objectFromPlistKey:@"name"];
  self.displayName = [[GDDPlistHelper sharedInstance]objectFromPlistKey:@"display_name"];
  self.token = [[GDDPlistHelper sharedInstance]objectFromPlistKey:@"token"];
  self.userID = [[GDDPlistHelper sharedInstance]objectFromPlistKey:@"userId"];
}
-(void)removeData{
  self.name = nil;
  self.displayName = nil;
  self.token = nil;
  self.userID = nil;
}
@end
