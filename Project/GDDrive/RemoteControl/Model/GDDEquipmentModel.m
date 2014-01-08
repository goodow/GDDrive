//
//  GDDEquipmentModel.m
//  GDDrive
//
//  Created by 大黄 on 14-1-8.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDEquipmentModel.h"

@interface GDDEquipmentModel ()

@property (nonatomic, copy,readwrite) NSString *equipmentID;

@end

@implementation GDDEquipmentModel

+ (id) sharedInstance; {
  static GDDEquipmentModel *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}
+(void)load{
  
}
+(void)initialize{
  
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
    [self readNSUserDefaults];
  }
  return self;
}
- (void)updateEquipmentID:(NSString *)equipmentID{
  self.equipmentID = equipmentID;
  [self saveNSUserDefaults];
}

-(void)saveNSUserDefaults
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:self.equipmentID forKey:@"equipmentID"];
  [userDefaults synchronize];
}

-(void)readNSUserDefaults
{
  NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
  //读取NSString类型的数据
  self.equipmentID = [userDefaultes stringForKey:@"equipmentID"];
}
-(NSString *)connectProtocol:(NSString *)pro{
    return [NSString stringWithFormat:@"%@.%@",self.equipmentID,pro];
}
@end
