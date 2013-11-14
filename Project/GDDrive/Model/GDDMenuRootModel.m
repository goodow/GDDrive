//
//  GDDMenuRootModel.m
//  GDDrive
//
//  Created by 大黄 on 13-11-15.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDMenuRootModel.h"
@interface GDDMenuRootModel()

@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) NSArray *labels;

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) UIImage *icon;

@end

@implementation GDDMenuRootModel

-(id)init{
  if (self = [super init]) {
    
  }
  return self;
}

-(id)initWithIcons:(NSArray *)aIcons labels:(NSArray *)aLabels{
  if (self = [super init]) {
    self.icons = aIcons;
    self.labels = aLabels;
  }
  return self;
}
-(void)setLabelWithIndex:(NSInteger)index{
  if (index < [self.labels count]) {
    self.label =  [self.labels count] ? [self.labels objectAtIndex:index] : @"";
  }else{
    self.label = @"";
  }
}
-(void)setIconWithIndex:(NSInteger)index{
  if (index < [self.icons count]) {
    self.icon =  [self.icons count] ? [UIImage imageNamed:[self.icons objectAtIndex:index]] : [UIImage imageNamed:@""];
  }else{
    self.icon = [UIImage imageNamed:@""];
  }
}
-(NSInteger)count{
  if (self.icons && self.labels && [self.icons count] == [self.labels count]) {
    return [self.labels count];
  }else{
    return 0;
  }

}
@end
