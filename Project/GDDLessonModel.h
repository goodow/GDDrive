//
//  GDDLessonModel.h
//  GDDrive
//
//  Created by 大黄 on 14-2-25.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDDLessonModel : NSObject

@property (nonatomic, strong, readwrite) NSString *selectedLesson;
@property (nonatomic, strong, readwrite) NSMutableArray *attachmentTags;
@property (nonatomic, strong, readwrite) NSMutableArray *activityTags;

// 获取资源目录结构
-(NSArray *)lessonNames;
-(NSDictionary *)resourceStructure;
// 获得初始化的最初Key值
-(NSString *)resourceInit;
@end
