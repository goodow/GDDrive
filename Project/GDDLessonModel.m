//
//  GDDLessonModel.m
//  GDDrive
//
//  Created by 大黄 on 14-2-25.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDLessonModel.h"

@interface GDDLessonModel ()

@property (nonatomic, strong) NSDictionary *lessonDictionary;
@property (nonatomic, strong) NSArray *lessons;

@end

@implementation GDDLessonModel

-(id)init{
  if (self =[super init]) {
    self.lessons = @[@"和谐",@"托班",@"入学准备",@"智能开发",@"电子书",@"示范课",@"收藏"];
    self.lessonDictionary = @{self.lessons[0]: @[@[@"小班",@"中班",@"大班",@"学前班"],@[@"上学期",@"下学期"],@[@"健康",@"语言",@"社会",@"科学",@"数学",@"艺术(音乐)",@"艺术(美术)"]],
                              self.lessons[1]:@[@[@"上学期",@"下学期"]],
                              self.lessons[2]: @[@[@"上学期",@"下学期"],@[@"语言",@"思维",@"阅读与书写",@"习惯与学习品质"]],
                              self.lessons[3]: @[@[@"小班",@"中班",@"大班",@"学前班"],@[@"上学期",@"下学期"]],
                              self.lessons[4]: @[@[@"冰波童话",@"快乐宝贝",@"其它"]],
                              self.lessons[5]:  @[@[@"小班",@"中班",@"大班",@"学前班"],@[@"上学期",@"下学期"],@[@"健康",@"语言",@"社会",@"科学",@"数学",@"艺术(音乐)",@"艺术(美术)"]],
                              self.lessons[6]: @[@[@"活动",@"文件"]]};
  }
  return self;
}
-(NSArray *)lessonNames{
  return self.lessons;
}
-(NSDictionary *)resourceStructure{
  return self.lessonDictionary;
}
-(NSString *)resourceInit{
  return self.lessons[0];
}
@end
