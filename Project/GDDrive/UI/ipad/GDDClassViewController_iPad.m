//
//  GDDClassViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDClassViewController_iPad.h"
#import "GDDUIBarButtonItem.h"
#import "GDDContentListCell_ipad.h"
#import "Boolean.h"
#import "GDDPlayPNGAndJPGViewController_ipad.h"

@interface GDDClassViewController_iPad ()
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

@property (nonatomic, strong) GDDPlayPNGAndJPGViewController_ipad *playPNGAndJPGViewController;

@property (nonatomic, assign) BOOL isControllerDealloc;
@end

static NSString * FOLDERS_KEY = @"folders";
static NSString * FILES_KEY = @"files";

@implementation GDDClassViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _isControllerDealloc = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.backBarButtonItem  = [[GDDUIBarButtonItem alloc] initWithRootTitle:@"我的课程" withClick:^{
    [self.currentPath remove:([self.currentPath length]-1)];
    [self.path set:@"currentpath" value:self.currentPath];
    [self.remotecontrolRoot set:@"path" value:self.path];
  }];
  self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
  
  //  [self loadRealtime];
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  self.isControllerDealloc = YES;
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
- (void)loadRealtime{
  
  __weak GDDClassViewController_iPad *weakSelf = self;
  [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",GDDConfigPlist(@"documentId"),GDDConfigPlist(@"userId"),GDDConfigPlist(@"lesson")]
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
             
           } opt_initializer:^(GDRModel *model) {
             
           } opt_error:^(GDRError *error) {
             
           }];
  
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
  UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  headerLabel.backgroundColor = [UIColor clearColor];
  headerLabel.opaque = NO;
  headerLabel.textColor = [UIColor grayColor];
  headerLabel.highlightedTextColor = [UIColor whiteColor];
  headerLabel.font = [UIFont boldSystemFontOfSize:16];
  headerLabel.frame = CGRectMake(0.0, 0.0, 300.0, 44.0);
  headerLabel.text = section ? @"文件" : @"文件夹";
  [customView addSubview:headerLabel];
  return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 44.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"GDDContentListCell_ipad";
  GDDContentListCell_ipad *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    UINib *nibObject =  [UINib nibWithNibName:@"GDDContentListCell_ipad" bundle:nil];
    NSArray *nibObjects = [nibObject instantiateWithOwner:nil options:nil];
    cell = [nibObjects objectAtIndex:0];
    [cell setBackgroundColor:[UIColor clearColor]];

    [self addObserver:cell forKeyPath:isControllerDealloc
              options:NSKeyValueObservingOptionNew
              context:(__bridge void*)cell];
  }
  
  if (indexPath.section == 0) {
    if ([self.folderList length]>0) {
      GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
      [cell bindWithDataBean:map];
    }
    return cell;
  }else{
    if ([self.filesList length]>0) {
      GDRCollaborativeMap *map = [self.filesList get:indexPath.row];
      [cell bindWithDataBean:map];
    }
    return cell;
  }
  
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //选择文件夹
  if (indexPath.section == 0) {
    GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
    id <GDJsonString> idStr = [GDJson createString:[map getId]];
    [self.currentPath insert:[self.currentPath length] value:idStr];
    [self.path set:@"currentpath" value:self.currentPath];
    [self.remotecontrolRoot set:@"path" value:self.path];
  }else{
    //这里先认为只是要播放png jpg资源
    GDRCollaborativeMap *map = [self.filesList get:indexPath.row];
    self.playPNGAndJPGViewController = [[GDDPlayPNGAndJPGViewController_ipad alloc]initWithNibName:@"GDDPlayPNGAndJPGViewController_ipad" bundle:nil];
    [self presentViewController:self.playPNGAndJPGViewController animated:YES completion:nil];
    [self.playPNGAndJPGViewController loadMultimediaWith:map];
  }
}
#pragma mark - GDRealtimeProtocol Override
-(void)loadRealtimeData:(GDRModel *)mod{
  self.remotecontrolRoot = [mod getRoot];
  __weak GDDClassViewController_iPad *weakSelf = self;
  weakSelf.path = [weakSelf.remotecontrolRoot get:@"path"];
  weakSelf.currentPath = [weakSelf.path get:@"currentpath"];
  weakSelf.currentID = [weakSelf.path get:@"currentdocid"];
  
  [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",GDDConfigPlist(@"documentId"),GDDConfigPlist(@"userId"),GDDConfigPlist(@"lesson")]
           onLoaded:^(GDRDocument *document) {
             weakSelf.doc = document;
             weakSelf.mod = [weakSelf.doc getModel];
             NSString *gdID = [[weakSelf.currentPath get:([weakSelf.currentPath length]-1)]getString];
             weakSelf.root = [weakSelf.mod getObjectWithNSString:gdID];
             weakSelf.folderList = [weakSelf.root get:FOLDERS_KEY];
             weakSelf.filesList = [weakSelf.root get:FILES_KEY];
             id block = ^(GDRBaseModelEvent *event) {
               [weakSelf.tableView reloadData];
             };
             [weakSelf.folderList addValuesAddedListener:block];
             [weakSelf.folderList addValuesRemovedListener:block];
             [weakSelf.folderList addValuesSetListener:block];
             [weakSelf.filesList addValuesAddedListener:block];
             [weakSelf.filesList addValuesRemovedListener:block];
             [weakSelf.filesList addValuesSetListener:block];
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
