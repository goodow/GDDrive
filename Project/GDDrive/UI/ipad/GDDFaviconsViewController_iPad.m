//
//  GDDFaviconsViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDFaviconsViewController_iPad.h"
#import "GDDUIBarButtonItem.h"

@interface GDDFaviconsViewController_iPad ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) GDDUIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) GDRDocument *doc;
@property (nonatomic, strong) GDRModel *mod;
@property (nonatomic, strong) GDRCollaborativeMap *root;
@property (nonatomic, strong) GDRCollaborativeList *folderList;
@property (nonatomic, strong) GDRCollaborativeList *filesList;

@property (nonatomic, strong) GDRCollaborativeMap *remotecontrolRoot;
@property (nonatomic, strong) id <GDJsonObject> path;
@property (nonatomic, strong) id <GDJsonArray> currentPath;
@property (nonatomic, strong) id <GDJsonString> currentID;
@end

static NSString * FOLDERS_KEY = @"folders";
static NSString * FILES_KEY = @"files";

@implementation GDDFaviconsViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.backBarButtonItem  = [[GDDUIBarButtonItem alloc] initWithRootTitle:@"我的收藏" withClick:^{
    [self.currentPath remove:([self.currentPath length]-1)];
    [self.path set:@"currentpath" value:self.currentPath];
    [self.remotecontrolRoot set:@"path" value:self.path];
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
  //选择文件
  GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
  id <GDJsonString> idStr = [GDJson createString:[map getId]];
  [self.currentPath insert:[self.currentPath length] value:idStr];
  [self.path set:@"currentpath" value:self.currentPath];
  [self.remotecontrolRoot set:@"path" value:self.path];
}

#pragma mark - GDRealtimeProtocol Override
-(void)loadRealtimeData:(GDRModel *)mod{
  self.remotecontrolRoot = [mod getRoot];
  
  __weak GDDFaviconsViewController_iPad *weakSelf = self;
  NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
  weakSelf.path = [weakSelf.remotecontrolRoot get:@"path"];
  weakSelf.currentPath = [weakSelf.path get:@"currentpath"];
  weakSelf.currentID = [weakSelf.path get:@"currentdocid"];
  
  [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",[dictionary objectForKey:@"documentId"],[dictionary objectForKey:@"userId"],@"favorites25"]
           onLoaded:^(GDRDocument *document) {
             weakSelf.doc = document;
             weakSelf.mod = [weakSelf.doc getModel];
             weakSelf.root = [weakSelf.mod getRoot];
             NSString *gdID = [[weakSelf.currentPath get:([weakSelf.currentPath length]-1)]getString];
             weakSelf.root = [weakSelf.mod getObjectWithNSString:gdID];
             [weakSelf.doc addDocumentSaveStateListener:^(GDRDocumentSaveStateChangedEvent *event) {
               if ([event isSaving] || [event isPending]) {
               }
             }];
             [weakSelf.mod addUndoRedoStateChangedListener:^(GDRUndoRedoStateChangedEvent *event) {
             }];
             weakSelf.folderList = [weakSelf.root get:FOLDERS_KEY];
             weakSelf.filesList = [weakSelf.root get:FILES_KEY];
             [weakSelf.tableView reloadData];
             
             //设置该页面的back显示
             id <GDJsonObject> changePath = [weakSelf.remotecontrolRoot get:@"path"];
             id <GDJsonArray> changeCurrentPath = [changePath get:@"currentpath"];
             NSMutableArray *historyIDs = [NSMutableArray array];
             NSMutableArray *historyNames = [NSMutableArray array];
             for (int i = 1; i<[changeCurrentPath length]; i++) {
               NSString *gdID = [[changeCurrentPath get:(i)]getString];
               [historyIDs addObject:gdID];
               GDRCollaborativeMap *changeRoot = [weakSelf.mod getObjectWithNSString:gdID];
               NSString *name = [changeRoot get:@"label"];
               [historyNames addObject:name];
             }
             [self.backBarButtonItem updateAllHistoryListWithHistoryID:historyIDs titles:historyNames];
             
           } opt_initializer:^(GDRModel *model) {
             
           } opt_error:^(GDRError *error) {
             
           }];
  
}
@end
