//
//  GDDOfflineFilesViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDOfflineFilesViewController_iPad.h"
#import "GDDUIBarButtonItem.h"
#import "GDDOfflineContentListCell_ipad.h"

@interface GDDOfflineFilesViewController_iPad ()

@end

@implementation GDDOfflineFilesViewController_iPad

#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  
  return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"GDDOfflineContentListCell_ipad";
  GDDOfflineContentListCell_ipad *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    UINib *nibObject =  [UINib nibWithNibName:@"GDDOfflineContentListCell_ipad" bundle:nil];
    NSArray *nibObjects = [nibObject instantiateWithOwner:nil options:nil];
    cell = [nibObjects objectAtIndex:0];
    [cell setBackgroundColor:[UIColor clearColor]];
  }
  return cell;
  
}
-(NSArray *)cellsForTableView:(UITableView *)tableView
{
  NSInteger sections = tableView.numberOfSections;
  NSMutableArray *cells = [[NSMutableArray alloc]  init];
  for (int section = 0; section < sections; section++) {
    NSInteger rows =  [tableView numberOfRowsInSection:section];
    for (int row = 0; row < rows; row++) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
      [cells addObject:[tableView cellForRowAtIndexPath:indexPath]];
    }
  }
  return cells;
}
-(NSString *)interfaceDescription{
  return @"离线下载";
}
-(NSString *)realtimeLoadLocation{
  return [NSString stringWithFormat:@"%@/%@/%@",GDDConfigPlist(@"documentId"),GDDConfigPlist(@"userId"),GDDConfigPlist(@"offlinedoc")];
}
-(NSString *)filesKey{
  return @"offline";
}
-(NSString *)foldersKey{
  return nil;
}

@end
