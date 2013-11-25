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
  self.backBarButtonItem  = [[GDDUIBarButtonItem alloc] initWithRootTitle:@"离线下载" withClick:^{
    [self.currentPath remove:([self.currentPath length]-1)];
    [self.path set:@"currentpath" value:self.currentPath];
    [self.remotecontrolRoot set:@"path" value:self.path];
  }];
  self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self removeAllObserversForTableView];
  [self.offLineList removeObjectChangedListener:self.offlinedocBlock];
  NSLog(@"viewWillDisappear");
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.offLineList length];
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
  if ([self.offLineList length]>0) {
    GDRCollaborativeMap *map = [self.offLineList get:indexPath.row];
    NSLog(@"%@",map);
    [cell bindWithDataBean:map];
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
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //选择文件
  //  GDRCollaborativeMap *map = [self.offLineList get:indexPath.row];
  //  id <GDJsonString> idStr = [GDJson createString:[map getId]];
  //  [self.currentPath insert:[self.currentPath length] value:idStr];
  //  [self.path set:@"currentpath" value:self.currentPath];
  //  [self.remotecontrolRoot set:@"path" value:self.path];
}

- (void)removeAllObserversForTableView {
  NSArray *subviews = [self cellsForTableView:self.tableView];
  for (id view in subviews) {
    if ([view isKindOfClass:[GDDOfflineContentListCell_ipad class]]) {
      //      GDDOfflineContentListCell_ipad *cell = view;
      //      [cell removeAllObserver];
      // 注销监听下载KVO
    }
  }
}

#pragma mark - GDRealtimeProtocol Override
-(void)loadRealtimeData:(GDRModel *)mod{
  self.remotecontrolRoot = [mod getRoot];
  __weak GDDOfflineFilesViewController_iPad *weakSelf = self;
  weakSelf.path = [weakSelf.remotecontrolRoot get:@"path"];
  weakSelf.currentPath = [weakSelf.path get:@"currentpath"];
  weakSelf.currentID = [weakSelf.path get:@"currentdocid"];
  [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",GDDConfigPlist(@"documentId"),GDDConfigPlist(@"userId"),GDDConfigPlist(@"offlinedoc")]
           onLoaded:^(GDRDocument *document) {
             weakSelf.doc = document;
             weakSelf.mod = [weakSelf.doc getModel];
             weakSelf.root = [weakSelf.mod getRoot];
             NSString *gdID = [[weakSelf.currentPath get:([weakSelf.currentPath length]-1)]getString];
             weakSelf.root = [weakSelf.mod getObjectWithNSString:gdID];
             //             [weakSelf.doc addDocumentSaveStateListener:^(GDRDocumentSaveStateChangedEvent *event) {
             //               if ([event isSaving] || [event isPending]) {
             //               }
             //             }];
             //             [weakSelf.mod addUndoRedoStateChangedListener:^(GDRUndoRedoStateChangedEvent *event) {
             //             }];
             weakSelf.offLineList = [weakSelf.root get:@"offline"];
             weakSelf.offlinedocBlock = ^(GDRBaseModelEvent *event) {
               [weakSelf.tableView reloadData];
             };
             [weakSelf.offLineList addObjectChangedListener:weakSelf.offlinedocBlock];
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
