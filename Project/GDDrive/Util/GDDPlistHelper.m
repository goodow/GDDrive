//
//  GDDPlistHelper.m
//  GDDrive
//
//  Created by 大黄 on 13-11-29.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDPlistHelper.h"

@implementation GDDPlistHelper
+ (GDDPlistHelper *) sharedInstance {
  static GDDPlistHelper *singletonInstance = nil;
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
+ (void)createPlistMirror{
  //读取plist 并在沙盒目录创建实体镜像
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSMutableDictionary *data = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath]mutableCopy];
  //  NSLog(@"%@", data);
  //获取应用程序沙盒的Documents目录
  NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
  NSString *plistPath1 = [paths objectAtIndex:0];
  //得到完整的文件名
  NSString *filename=[plistPath1 stringByAppendingPathComponent:@"config.plist"];
  //输入写入
  [data writeToFile:filename atomically:YES];
}
-(NSDictionary *)infolist{
  NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"config.plist"];
  //  NSLog(@"%@", [[NSMutableDictionary alloc]initWithContentsOfFile:path]);
  return [[NSMutableDictionary alloc]initWithContentsOfFile:path];
  
}
-(NSString *)objectFromPlistKey:(NSString *)key{
  return [[self infolist] objectForKey:key];
}
-(void)setInPlistObject:(id)object forKey:(id)key {
  NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"config.plist"];
  NSMutableDictionary *infolist= [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
  [infolist setObject:object forKey:key];
  [infolist writeToFile:path atomically:YES];
}

@end
