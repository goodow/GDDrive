//
//  GDDUIBarButtonItemDelegate.h
//  GDDrive
//
//  Created by 大黄 on 13-10-31.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDUIBarButtonItem.h"

@interface GDDUIBarButtonItem()

@property (nonatomic, strong) NSMutableArray *historyIDs;
@property (nonatomic, strong) NSMutableArray *historyNames;
@property (nonatomic, strong) GDDUIBarButtonItemClickBlock barButtonItemClickBlock;

@end

static NSString *BREAK = @" > ";

@implementation GDDUIBarButtonItem
-(id)initWithRootTitle:(NSString *)title withClick:(GDDUIBarButtonItemClickBlock)block{
  if (self = [super initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backButtonItemListener:)]) {
    self.historyIDs = [NSMutableArray array];
    self.historyNames = [NSMutableArray array];
    self.barButtonItemClickBlock = block;
  }
  return self;
}
-(void)updateAllHistoryListWithHistoryID:(NSArray *)hids titles:(NSArray *)titles{
  [self.historyIDs removeAllObjects];
  [self.historyNames removeAllObjects];
  self.historyIDs = [NSMutableArray arrayWithArray:hids];
  self.historyNames = [NSMutableArray arrayWithArray:titles];
  [self refreshData];
}
-(void)refreshData{
  NSArray *array= [self.title componentsSeparatedByString:BREAK];
  NSString *rootStr = [array objectAtIndex:0];
  NSMutableString *finalStr = [[NSMutableString alloc]initWithString:rootStr];
  for (NSString *title in self.historyNames) {
    [finalStr appendFormat:@"%@%@",BREAK,title];
  }
  self.title = finalStr;
}

#pragma mark -IBAction
-(IBAction)backButtonItemListener:(id)sender{
  if ([self.historyIDs count] > 0) {
    self.barButtonItemClickBlock();
  }
}


@end
