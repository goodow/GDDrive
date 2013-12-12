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
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) GDDUIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) GDRDocument *doc;
@property (nonatomic, strong) GDRModel *mod;
@property (nonatomic, strong) GDRCollaborativeMap *root;
@property (nonatomic, strong) GDRCollaborativeList *offLineList;

@property (nonatomic, strong) GDRCollaborativeMap *remotecontrolRoot;
@property (nonatomic, strong) id <GDJsonObject> path;
@property (nonatomic, strong) id <GDJsonArray> currentPath;
@property (nonatomic, strong) id <GDJsonString> currentID;

@property (nonatomic, strong) id offlinedocBlock;

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
