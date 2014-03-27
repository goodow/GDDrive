//
//  GDDEditableCellModel.m
//  GDDrive
//
//  Created by 大黄 on 14-3-28.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDEditableCellModel.h"

@implementation GDDEditableCellModel

- (id)initWithDataSource:(NSArray *)dataSource{
  if (self = [super init]) {
    _dataSource = dataSource;
    _selectedTagArray = [self createSelectedTagArrayByValue:NO];
  }
  return self;
}
- (NSMutableArray *)createSelectedTagArrayByValue:(BOOL)value {
  NSMutableArray *selectedTagArray = [NSMutableArray arrayWithCapacity:_dataSource.count];
  for (int i = 0; i < _dataSource.count; i++) {
    [selectedTagArray addObject:[NSNumber numberWithBool:value]];
  }
  return selectedTagArray;
}

- (void)setSelectedTagByIndex:(NSUInteger)index value:(BOOL)value{
  if ( index >= _dataSource.count) {
    NSLog(@"数组越界错误");
    return;
  }
  [(NSMutableArray *)_selectedTagArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:value]];
}
- (BOOL)selectedTagByIndex:(NSUInteger)index{
  if ( index >= _dataSource.count) {
    NSLog(@"数组越界错误");
    return NO;
  }
  return [[_selectedTagArray objectAtIndex:index]boolValue];
}
- (void)setALLSelectedTagByValue:(BOOL)value{
  _selectedTagArray = [self createSelectedTagArrayByValue:value];
}


@end
