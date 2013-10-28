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
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;

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
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];  
  
  __block GDDClassViewController_iPad *blockSelf = self;
  GDRModelInitializerBlock initializer = ^(GDRModel * model){
//    GDRCollaborativeMap *root = [model getRoot];
//    GDRCollaborativeString *string = [model createString:@"Edit Me!"];
//    [root set:FOLDERS_KEY value:string];
  };
  GDRDocumentLoadedBlock onLoaded = ^(GDRDocument *document) {
    
    blockSelf.doc = document;
    blockSelf.mod = [self.doc getModel];
    blockSelf.root = [self.mod getRoot];
    
    
    [blockSelf.doc addDocumentSaveStateListener:^(GDRDocumentSaveStateChangedEvent *event) {
      if ([event isSaving] || [event isPending]) {
       
      }
    }];
    [blockSelf.mod addUndoRedoStateChangedListener:^(GDRUndoRedoStateChangedEvent *event) {

    }];
//    self.str = [self.root get:STR_KEY];
//    self.textView.text = [self.str getText];
//    id block = ^(GDRBaseModelEvent *event) {
//      self.textView.text = [self.str getText];
//    };
//    [self.str addObjectChangedListener:block];
    
    blockSelf.folderList = [self.root get:FOLDERS_KEY];
    blockSelf.filesList = [self.root get:FILES_KEY];
    
    NSLog(@"blockSelf.folderList：%@",blockSelf.folderList);
    [blockSelf.tableView reloadData];
  };
  NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
  [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",[dictionary objectForKey:@"documentId"],[dictionary objectForKey:@"userId"],@"lesson07"]
           onLoaded:onLoaded
    opt_initializer:initializer
          opt_error:nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [self.folderList length] + [self.filesList length];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CollaborativeListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
//  cell.textLabel.text = [self.folderList length] > 0 ?  @"":[self.folderList get:indexPath.row];
  if ([self.folderList length]>0) {
    GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
    NSLog(@"%@",map);
    cell.textLabel.text = [map get:@"label"];
  }
  return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  GDDClassViewController_iPad *classViewController=[[GDDClassViewController_iPad alloc] initWithNibName:@"GDDClassViewController_iPad" bundle:nil];
  [self.navigationController pushViewController:classViewController animated:YES];
  
}


@end
