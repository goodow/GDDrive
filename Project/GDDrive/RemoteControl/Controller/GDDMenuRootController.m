//
//  GDDMenuRootController.m
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDMenuRootController.h"
#import "GDDFaviconsViewController_iPad.h"
#import "GDDOfflineFilesViewController_iPad.h"
#import "GDDRemoteControlViewController.h"
#import "GDDRealtimeDataToViewController.h"
#import "PSStackedView.h"
#import "AppDelegate.h"
#import "GDDMenuRootCell_ipad.h"
#import "GDDMenuRootModel.h"
#import "GDDLoginView_ipad.h"
#import "UIAlertView+Blocks.h"
#import "GDDMainViewController_ipad.h"
#import "GDDEquipmentView.h"
#import "GDDAddr.h"
#import "GDDBusProvider.h"
#import "GDDSettingsViewController.h"
#import "UIAlertView+Blocks.h"
#import "GDDLessonViewController.h"
#import "GDDActivityViewController.h"

typedef enum {
  GDDMENU_PAGE_LESSON = 0,
  GDDMENU_PAGE_COLLECT = 1,
  GDDMENU_PAGE_REMOTE_CONTROL = 2,
  GDDMENU_PAGE_SETTINGS = 3,
  GDDMENU_PAGE_ACTIVITY = 4
} GDDMENU_PAGE_TYPE;

@interface GDDMenuRootController ()
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSMutableArray *childViewController;
@property (nonatomic, strong) GDDMenuRootModel *menuRootModel;

@property (nonatomic, strong) id remotecontrolBlock;
@property (nonatomic, strong) GDDEquipmentView *equipmentView;
@property (nonatomic, strong) id<GDCHandlerRegistration> menuChangeHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> menuSettingsHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> notificationHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> activityHandlerRegistration;
@end

@implementation GDDMenuRootController

- (void)viewDidLoad
{
  [super viewDidLoad];
  //登陆信息与设置
  UINib *nibObject =  [UINib nibWithNibName:@"GDDEquipmentView" bundle:nil];
  NSArray *nibObjects = [nibObject instantiateWithOwner:nil options:nil];
  self.equipmentView = [nibObjects objectAtIndex:0];
  [self.equipmentView bindData];
  __weak GDDMenuRootController *weakSelf = self;
  [self.equipmentView setClickBlock:^{
    [UIAlertView showAlertViewWithTitle:@"切换设备"
                                message:@"是否要切换设备?"
                      cancelButtonTitle:@"cancal"
                      otherButtonTitles:@[@"sure"]
                         alertViewStyle:UIAlertViewStylePlainTextInput
                              onDismiss:^(UIAlertView *alertView, int buttonIndex) {
                                UITextField *tf=[alertView textFieldAtIndex:0];
                                NSLog(@"textInputContextIdentifier:%@",tf.text);
                                [GDDAddr updateEquipmentID:tf.text];
                                [weakSelf.equipmentView bindData];
                              }
                               onCancel:^{
                                 
                               }];
  }];
  self.menuTableView.tableHeaderView = self.equipmentView;
  self.menuRootModel = [[GDDMenuRootModel alloc]initWithIcons:@[@"class_icon.png", @"favicons_icon.png", @"offline_files_icon.png", @"offline_files_icon.png", @"offline_files_icon.png"]
                                                       labels:@[@"课程", @"收藏", @"遥控器" ,@"设置" ,@"活动"]];
  
  if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
  }
  
  
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
  
  //课程界面
  GDDLessonViewController *lessonViewController = [[GDDLessonViewController alloc] initWithNibName:@"GDDLessonViewController" bundle:nil];
  UINavigationController *lessonNavigationController = [[UINavigationController alloc]initWithRootViewController:lessonViewController];
  [self.childViewController addObject:lessonNavigationController];
  
  GDDMainViewController_ipad *faviconsViewController=[[GDDFaviconsViewController_iPad alloc] initWithNibName:@"GDDMainViewController_ipad" bundle:nil];
  UINavigationController *faviconsNavigationController = [[UINavigationController alloc]initWithRootViewController:faviconsViewController];
  [self.childViewController addObject:faviconsNavigationController];
  
  /**
   * 离线下载 ViewController 这里暂时屏蔽，之后还会使用
  GDDMainViewController_ipad *offlineFilesViewController = [[GDDOfflineFilesViewController_iPad alloc] initWithNibName:@"GDDMainViewController_ipad" bundle:nil];
  self.offlineNavigationController = [[UINavigationController alloc]initWithRootViewController:offlineFilesViewController];
  [self.childViewController addObject:self.offlineNavigationController];
   */
  
  GDDRemoteControlViewController *remoteControlViewController = [[GDDRemoteControlViewController alloc]initWithNibName:@"GDDRemoteControlViewController" bundle:nil];
  UINavigationController *remoteControlNavigationController = [[UINavigationController alloc]initWithRootViewController:remoteControlViewController];
  [self.childViewController addObject:remoteControlNavigationController];
  
  GDDSettingsViewController *settingsViewController = [[GDDSettingsViewController alloc]initWithNibName:@"GDDSettingsViewController" bundle:nil];
  UINavigationController *settingsNavigationController = [[UINavigationController alloc]initWithRootViewController:settingsViewController];
  [self.childViewController addObject:settingsNavigationController];
  
  GDDActivityViewController *activityViewController = [[GDDActivityViewController alloc] initWithNibName:@"GDDActivityViewController" bundle:nil];
  UINavigationController *activityNavigationController = [[UINavigationController alloc] initWithRootViewController:activityViewController];
  [self.childViewController addObject:activityNavigationController];

  __weak GDDMenuRootController *weakSelf = self;
  //注册监听 外部控制跳转课程/收藏/遥控器
  self.menuChangeHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr addressProtocol:ADDR_TOPIC addressStyle:GDDAddrReceive] handler:^(id<GDCMessage> message) {
    NSArray *tags = [message body][@"tags"];
    NSInteger i = 0;
    do {
      if ([tags count] <= 0) {
        break;
      }
      NSArray *lessons = @[@"和谐",@"托班",@"入学准备",@"智能开发",@"电子书",@"示范课"];
      //和谐 托班 等课程标签这里被检索 并统一这些标签都在 GDDMENU_PAGE_LESSON 界面 展示
      if (![lessons containsObject:tags[i]]) {
        i++;
        continue;
      }
      [weakSelf transitionChildViewControllerByIndex:GDDMENU_PAGE_LESSON];
      [[GDDBusProvider BUS] publish:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_CLASS addressStyle:GDDAddrSendLocal] message:[message body]];
      i++;
    } while (i < [tags count]);
  }];
  //注册监听 外部控制设置界面跳转
  self.menuSettingsHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr addressProtocol:ADDR_VIEW addressStyle:GDDAddrReceive] handler:^(id<GDCMessage> message) {
    NSLog(@"注册监听 外部控制设置界面跳转");
    if ([message body][@"settings"]) {
      [weakSelf transitionChildViewControllerByIndex:GDDMENU_PAGE_SETTINGS];
      [[GDDBusProvider BUS] publish:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_SETTINGS addressStyle:GDDAddrSendLocal] message:nil];      
    }
  }];
  //注册监听 信息通知
  self.notificationHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr addressProtocol:ADDR_NOTIFICATION addressStyle:GDDAddrReceive] handler:^(id<GDCMessage> message) {
    [UIAlertView showAlertViewWithTitle:@"消息通知"
                                message:[message body][@"content"]
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil
                         alertViewStyle:UIAlertViewStyleDefault
                              onDismiss:^(UIAlertView *alertView, int buttonIndex) {}
                               onCancel:^{}];
  }];
  //监听是否要跳转到活动界面
  self.activityHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_TOPIC_ACTIVITY addressStyle:GDDAddrReceive] handler:^(id<GDCMessage> message) {
    NSLog(@"%@",[message body]);
    [weakSelf transitionChildViewControllerByIndex:GDDMENU_PAGE_ACTIVITY];
    [[GDDBusProvider BUS] send:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_ACTIVITY_DATA addressStyle:GDDAddrSendLocal] message:[message body] replyHandler:nil];
  }];
}

-(void)transitionChildViewControllerByIndex:(NSInteger)index{

  if (index == GDDMENU_PAGE_REMOTE_CONTROL) {
    [GDDRemoteControlDelegate.stackController popViewControllerAnimated:YES];
    [GDDRemoteControlDelegate.stackController.rootViewController presentViewController:[self.childViewController objectAtIndex:index] animated:YES completion:nil];
    self.currentViewController = [self.childViewController objectAtIndex:index];
  }else{
    if (self.currentViewController == [self.childViewController objectAtIndex:index]) return;
    [GDDRemoteControlDelegate.stackController popViewControllerAnimated:YES];
    [GDDRemoteControlDelegate.stackController pushViewController:[self.childViewController objectAtIndex:index] fromViewController:nil animated:NO];
    self.currentViewController = [self.childViewController objectAtIndex:index];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.menuTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  }
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
  if (indexPath.row == GDDMENU_PAGE_REMOTE_CONTROL) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }

  [self transitionChildViewControllerByIndex:indexPath.row];
}

@end