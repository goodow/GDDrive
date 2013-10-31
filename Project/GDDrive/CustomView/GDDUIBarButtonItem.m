//
//  GDDUIBarButtonItemDelegate.h
//  GDDrive
//
//  Created by 大黄 on 13-10-31.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDUIBarButtonItem.h"

@interface GDDUIBarButtonItem()

@property (nonatomic, strong) NSMutableArray *historyList;
@property (nonatomic, strong) GDDUIBarButtonItemClickBlock barButtonItemClickBlock;

@end

static NSString *BREAK = @" > ";

@implementation GDDUIBarButtonItem
-(id)initWithRootTitle:(NSString *)title withClick:(GDDUIBarButtonItemClickBlock)block{
  if (self = [super initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backButtonItemListener:)]) {
    self.historyList = [NSMutableArray array];
    self.barButtonItemClickBlock = block;
  }
  return self;
}
-(void)addHistoryData:(NSObject *)obj pushTitleBySelectIndex:(NSInteger)index{
  [self.historyList addObject:obj];
  [self pushTitle:index];
}
-(IBAction)backButtonItemListener:(id)sender{
  if ([self.historyList count] > 0) {
    self.barButtonItemClickBlock();
  }
}
-(id)historyLastObjectAndRemoveIt{
  NSMutableArray *aHistoryList = [self.historyList lastObject];
  [self.historyList removeLastObject];
  [self popTitle];
  return aHistoryList;
}
-(void)pushTitle:(NSInteger)index{
  GDRCollaborativeMap *map = [(GDRCollaborativeList *)[self.historyList lastObject] get:index];
  NSMutableString *finalStr = [[NSMutableString alloc]initWithString:self.title];
  [finalStr appendFormat:@"%@%@",BREAK,[map get:@"label"]];
  self.title = finalStr;
}
-(void)popTitle{
  NSArray *array= [self.title componentsSeparatedByString:BREAK];
  NSMutableString *finalStr = [[NSMutableString alloc]initWithString:[array objectAtIndex:0]];
  for (int i = 1; i<[array count]-1; i++) {
    [finalStr appendFormat:@"%@%@",BREAK,[array objectAtIndex:i]];
  }
  self.title = finalStr;
}
@end
