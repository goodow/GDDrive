//
//  GDDMainViewController_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-12-12.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDMainViewController_ipad.h"
#import "GDDUIBarButtonItem.h"
#import "GDDContentListCell_ipad.h"
#import "Boolean.h"
#import "GDDPlayPNGAndJPGViewController_ipad.h"
#import "GDDPlayPDFViewController_ipad.h"
#import "GDDPlayMovieViewController_ipad.h"
#import "GDDPlayAudioViewController_ipad.h"
#import "UIAlertView+Blocks.h"
#import "GDDOffineFilesHelper.h"

@interface GDDMainViewController_ipad ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GDDUIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) id modelBlock;

@property (nonatomic, strong) GDDPlayPNGAndJPGViewController_ipad *playPNGAndJPGViewController;
@property (nonatomic, strong) GDDPlayPDFViewController_ipad *playPDFViewController;
@property (nonatomic, strong) GDDPlayMovieViewController_ipad *playMovieViewController;
@property (nonatomic, strong) GDDPlayAudioViewController_ipad *playAudioViewController;
@property (nonatomic, assign) BOOL isControllerDealloc;

@end

static NSString * FOLDERS_KEY = @"folders";
static NSString * FILES_KEY = @"files";


@implementation GDDMainViewController_ipad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _isControllerDealloc = NO;
  }
  return self;
}

-(void)setMainViewControllerProtocol:(id <GDDMainViewController_ipad>)protocol{
  self.mainViewControllerProtocol = protocol;
}
-(void)resetIsControllerDeallocTag{
  self.isControllerDealloc = NO;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.backBarButtonItem  = [[GDDUIBarButtonItem alloc] initWithRootTitle:[self interfaceDescription] withClick:^{
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
  // Dispose of any resources that can be recreated.
}

- (void)loadRealtime{
}

#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
  
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
  
  if (self.tableView.numberOfSections >1) {
    headerLabel.text = section ? @"文件" : @"文件夹";
  }else{
    headerLabel.text = @"文件";
  }
  
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

  return cell;
  
}
-(void)openFoldersAtIndexPath:(NSIndexPath *)indexPath{

}
-(void)openFilesAtIndexPath:(NSIndexPath *)indexPath{
 
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (self.tableView.numberOfSections >1) {
    if (indexPath.section == 0) {
      //选择文件夹
      [self openFoldersAtIndexPath:indexPath];
    }else{
      //选择文件
      [self openFilesAtIndexPath:indexPath];
    }
  }else{
    //选择文件
    [self openFilesAtIndexPath:indexPath];
  }
}

#pragma mark Abstract
-(NSString *)interfaceDescription{
  DLog(@"Abstract must realize");
  return @"";
}
-(NSString *)realtimeLoadLocation{
  DLog(@"Abstract must realize");
  return @"";
}
-(NSString *)filesKey{
  DLog(@"Abstract must realize");
  return nil;
}
-(NSString *)foldersKey{
  DLog(@"Abstract must realize");
  return nil;
}
@end
