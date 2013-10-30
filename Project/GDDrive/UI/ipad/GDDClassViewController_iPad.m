//
//  GDDClassViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDClassViewController_iPad.h"

@interface GDDClassViewController_iPad ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) GDRDocument *doc;
@property (nonatomic, strong) GDRModel *mod;
@property (nonatomic, strong) GDRCollaborativeMap *root;
@property (nonatomic, strong) GDRCollaborativeList *folderList;
@property (nonatomic, strong) GDRCollaborativeList *filesList;
@property (nonatomic, strong) NSMutableArray *historyList;
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
  
  self.backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的课程" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonItemListener:)];
  self.navigationItem.leftBarButtonItem = self.backButtonItem;
  self.historyList = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.folderList length] + [self.filesList length];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CollaborativeListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  if ([self.folderList length]>0) {
    GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
    cell.textLabel.text = [map get:@"label"];
  }
  return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.historyList addObject:self.folderList];
  GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
  NSMutableString *finalStr = [[NSMutableString alloc]initWithString:self.backButtonItem.title];
  [finalStr appendFormat:@" < %@",[map get:@"label"]];
  self.backButtonItem.title = finalStr;
  self.folderList = [map get:FOLDERS_KEY];
  self.filesList = [map get:FILES_KEY];
  [self.tableView reloadData];
}

#pragma mark -IBAction
-(IBAction)backButtonItemListener:(id)sender{
  if ([self.historyList count] > 0) {
    self.folderList = [self.historyList lastObject];
    [self.historyList removeLastObject];
    [self.tableView reloadData];
    NSArray *array= [self.backButtonItem.title componentsSeparatedByString:@" < "];
    NSMutableString *finalStr = [[NSMutableString alloc]initWithString:[array objectAtIndex:0]];
    for (int i = 1; i<[array count]-1; i++) {
      [finalStr appendFormat:@" < %@",[array objectAtIndex:i]];
    }
    self.backButtonItem.title = finalStr;
  }
}
@end
