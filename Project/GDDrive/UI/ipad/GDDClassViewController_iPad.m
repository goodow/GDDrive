//
//  GDDClassViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDClassViewController_iPad.h"
#import "GDDUIBarButtonItem.h"

@interface GDDClassViewController_iPad ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) GDDUIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) GDRDocument *doc;
@property (nonatomic, strong) GDRModel *mod;
@property (nonatomic, strong) GDRCollaborativeMap *root;
@property (nonatomic, strong) GDRCollaborativeList *folderList;
@property (nonatomic, strong) GDRCollaborativeList *filesList;
@end

static NSString * FOLDERS_KEY = @"folders";
static NSString * FILES_KEY = @"files";

@implementation GDDClassViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  __weak GDDClassViewController_iPad *weakSelf = self;
  NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
  [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",[dictionary objectForKey:@"documentId"],[dictionary objectForKey:@"userId"],@"lesson25"]
           onLoaded:^(GDRDocument *document) {
             weakSelf.doc = document;
             weakSelf.mod = [weakSelf.doc getModel];
             weakSelf.root = [weakSelf.mod getRoot];
             [weakSelf.doc addDocumentSaveStateListener:^(GDRDocumentSaveStateChangedEvent *event) {
               if ([event isSaving] || [event isPending]) {
               }
             }];
             [weakSelf.mod addUndoRedoStateChangedListener:^(GDRUndoRedoStateChangedEvent *event) {
             }];
             weakSelf.folderList = [weakSelf.root get:FOLDERS_KEY];
             weakSelf.filesList = [weakSelf.root get:FILES_KEY];
             NSLog(@"weakSelf.folderList：%@",weakSelf.folderList);
             [weakSelf.tableView reloadData];
           } opt_initializer:^(GDRModel *model) {
             
           } opt_error:^(GDRError *error) {
             
           }];
  
  self.backBarButtonItem  = [[GDDUIBarButtonItem alloc] initWithRootTitle:@"我的课程" withClick:^{
    self.folderList = [self.backBarButtonItem historyLastObjectAndRemoveIt];
    [self.tableView reloadData];
  }];
  self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return section == 0 ? [self.folderList length] : [self.filesList length];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  
  return section == 0 ? @"文件夹" : @"文件";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CollaborativeListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  if (indexPath.section == 0) {
    if ([self.folderList length]>0) {
      GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
      cell.textLabel.text = [map get:@"label"];
    }
    return cell;
  }else{
    if ([self.filesList length]>0) {
      GDRCollaborativeMap *map = [self.filesList get:indexPath.row];
      cell.textLabel.text = [map get:@"label"];
    }
    return cell;
  }
  
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.backBarButtonItem addHistoryData:self.folderList pushTitleBySelectIndex:indexPath.row];
  GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
  self.folderList = [map get:FOLDERS_KEY];
  self.filesList = [map get:FILES_KEY];
  [self.tableView reloadData];
}
@end
