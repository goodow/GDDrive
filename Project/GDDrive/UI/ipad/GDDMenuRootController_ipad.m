//
//  GDDMenuRootController.m
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDMenuRootController_ipad.h"
#import "GDDClassViewController_iPad.h"
#import "GDDFaviconsViewController_iPad.h"
#import "GDDOfflineFilesViewController_iPad.h"
#import "GDDRealtimeDataToViewController.h"
#import "PSStackedView.h"
#import "GDDAppDelegate.h"
#import "GDDMenuRootCell_ipad.h"
#import "GDDMenuRootModel.h"
#import "GDDLoginView_ipad.h"
#import "UIAlertView+Blocks.h"
#import "GDDMainViewController_ipad.h"

@interface GDDMenuRootController_ipad ()
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) id <GDRealtimeProtocol> realtimeProtocol;

@property (nonatomic, strong) UINavigationController *classNavigationController;
@property (nonatomic, strong) UINavigationController *faviconsNavigationController;
@property (nonatomic, strong) UINavigationController *offlineNavigationController;
@property (nonatomic, strong) UINavigationController *descriptionMessageNavigationController;
@property (nonatomic, strong) NSMutableArray *childViewController;
@property (nonatomic, strong) GDDMenuRootModel *menuRootModel;

@property (nonatomic, strong) id remotecontrolBlock;
@end

@implementation GDDMenuRootController_ipad

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.menuRootModel = [[GDDMenuRootModel alloc]initWithIcons:@[@"class_icon.png", @"favicons_icon.png", @"offline_files_icon.png"] labels:@[@"我的课程", @"我的收藏", @"我的下载"]];

}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
-(void)loadRealtime{
  
  self.childViewController = [NSMutableArray array];
  
  GDDMainViewController_ipad *classViewController=[[GDDClassViewController_iPad alloc] initWithNibName:@"GDDMainViewController_ipad" bundle:nil];
  self.classNavigationController = [[UINavigationController alloc]initWithRootViewController:classViewController];
  [self.childViewController addObject:self.classNavigationController];
  
  GDDMainViewController_ipad *faviconsViewController=[[GDDFaviconsViewController_iPad alloc] initWithNibName:@"GDDMainViewController_ipad" bundle:nil];
  self.faviconsNavigationController = [[UINavigationController alloc]initWithRootViewController:faviconsViewController];
  [self.childViewController addObject:self.faviconsNavigationController];
  
  GDDMainViewController_ipad *offlineFilesViewController = [[GDDOfflineFilesViewController_iPad alloc] initWithNibName:@"GDDMainViewController_ipad" bundle:nil];
  self.offlineNavigationController = [[UINavigationController alloc]initWithRootViewController:offlineFilesViewController];
  [self.childViewController addObject:self.offlineNavigationController];
  
  __weak GDDMenuRootController_ipad *weakSelf = self;
  self.realtimeProtocol = [[GDDRealtimeDataToViewController alloc]
                           initWithTransitionFromChildViewControllerToViewControllerBlock:^(NSInteger i) {
                             [weakSelf transitionChildViewControllerByIndex:i];
                           } ObjectsAndKeys:
                           classViewController,GDDConfigPlist(@"lesson"),
                           faviconsViewController,GDDConfigPlist(@"favorites"),
                           offlineFilesViewController,GDDConfigPlist(@"offlinedoc"),nil];
  
  
}
-(void)transitionChildViewControllerByIndex:(NSInteger)index{
  if (self.currentViewController == [self.childViewController objectAtIndex:index]) return;
  [GDDRiveDelegate.stackController popViewControllerAnimated:YES];
  [GDDRiveDelegate.stackController pushViewController:[self.childViewController objectAtIndex:index] fromViewController:nil animated:NO];
  self.currentViewController = [self.childViewController objectAtIndex:index];
  
  NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
  [self.menuTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  
}
-(void)transitionChildViewControllerAndIntoRootPathByKey:(NSString *)key{
  
}
#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.menuRootModel count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.menuRootModel setLabelWithIndex:indexPath.row];
  [self.menuRootModel setIconWithIndex:indexPath.row];
  static NSString *CellIdentifier = @"GDDMenuRootCell_ipad";
  GDDMenuRootCell_ipad *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    UINib *nibObject =  [UINib nibWithNibName:@"GDDMenuRootCell_ipad" bundle:nil];
    NSArray *nibObjects = [nibObject instantiateWithOwner:nil options:nil];
    cell = [nibObjects objectAtIndex:0];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setPropertys:@[@"label",@"icon"]];
    [cell setObject:self.menuRootModel];
    
    //设置cell点击背景效果
    UIView *cellBackView = [[UIView alloc]init];
    UIImageView *cellBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_selected_style_black.png"]];
    [cellBackImageView setFrame:cell.bounds];
    [cellBackView addSubview:cellBackImageView];
    [cell setSelectedBackgroundView:cellBackView];
  }
  return cell;
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self transitionChildViewControllerByIndex:indexPath.row];
  
}
@end