//
//  GDDSettingsViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-2-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDSettingsViewController.h"
#import "GDDAddr.h"
#import "GDDBusProvider.h"
#import "GDDLocationTableViewController.h"
#import "GDDInformationTableViewController.h"

@interface GDDSettingsViewController ()
@property (nonatomic, strong) IBOutlet UIView *localTableView;
@property (nonatomic, strong) IBOutlet UIView *informationTableView;
@property (nonatomic, strong) IBOutlet UITextField *notificationTextField;
@property (nonatomic, strong) IBOutlet UILabel *connectivityTypeLable;
@property (nonatomic, strong) IBOutlet UILabel *connectivityStrengthLable;
@property (nonatomic, strong) GDDLocationTableViewController *locationTableViewController;
@property (nonatomic, strong) GDDInformationTableViewController *informationTableViewController;
@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, strong) id<GDCHandlerRegistration> switchSettingsHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> switchSettingsAboutUsHandlerRegistration;
@end

@implementation GDDSettingsViewController

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
  self.navigationItem.title = @"设置";
  self.bus = [GDDBusProvider BUS];
  
  self.locationTableViewController= [[GDDLocationTableViewController alloc]initWithNibName:@"GDDLocationTableViewController" bundle:nil];
  [self addChildViewController:self.locationTableViewController];
  [self.localTableView addSubview:self.locationTableViewController.tableView];
  
  self.informationTableViewController= [[GDDInformationTableViewController alloc]initWithNibName:@"GDDInformationTableViewController" bundle:nil];
  [self addChildViewController:self.informationTableViewController];
  [self.informationTableView addSubview:self.informationTableViewController.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  __weak GDDSettingsViewController *weakSelf = self;
  self.switchSettingsHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr SWITCH_SETTINGS:GDDAddrReceive] handler:^(id<GDCMessage> message){
    [[GDDBusProvider BUS] send:[GDDAddr SETTINGS:GDDAddrSendRemote] message:@{} replyHandler:nil];
  }];
  self.switchSettingsAboutUsHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr SETTINGS_ABOOUT_US:GDDAddrReceive] handler:^(id<GDCMessage> message) {
    NSLog(@"注册监听 外部控制设置界面-关于我们跳转");
    [weakSelf aboutUsAction:nil];
  }];
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.switchSettingsHandlerRegistration unregisterHandler];
  [self.switchSettingsAboutUsHandlerRegistration unregisterHandler];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
#pragma mark -UITextFeild delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}
#pragma mark -IBAction
-(IBAction)settingsWifiAction:(id)sender{
  [self.bus send:[GDDAddr SETTINGS_WIFI:GDDAddrSendRemote] message:@{} replyHandler:nil];
}
-(IBAction)resolutionAction:(id)sender{
  [self.bus send:[GDDAddr SETTINGS_RESOLUTION:GDDAddrSendRemote] message:@{} replyHandler:nil];
}
-(IBAction)screenOffSetAction:(id)sender{
  [self.bus send:[GDDAddr SETTINGS_SCREEN_OFFSET:GDDAddrSendRemote] message:@{} replyHandler:nil];
}
-(IBAction)aboutUsAction:(id)sender{
  [self.bus send:[GDDAddr SETTINGS_ABOOUT_US:GDDAddrSendRemote] message:@{} replyHandler:nil];
}
-(IBAction)locationAction:(id)sender{
  [self.bus send:[GDDAddr SETTINGS_LOCATION:GDDAddrSendRemote] message:@{} replyHandler:^(id<GDCMessage> message) {
    [self.locationTableViewController bindData:[message body]];
  }];
}
-(IBAction)informationAction:(id)sender{
  [self.bus send:[GDDAddr SETTINGS_INFORMATION:GDDAddrSendRemote] message:@{} replyHandler:^(id<GDCMessage> message) {
    [self.informationTableViewController bindData:[message body]];
  }];
}
-(IBAction)notificationAction:(id)sender{
  [self.notificationTextField resignFirstResponder];
  if (![self.notificationTextField.text isEqualToString:@""] && self.notificationTextField.text != nil) {
    [self.bus send:[GDDAddr NOTIFICATION:GDDAddrSendRemote] message:@{@"content":self.notificationTextField.text} replyHandler:nil];
  }
}
-(IBAction)connectivityAction:(id)sender{
  [self.bus send:[GDDAddr SETTINGS_CONNECTIVITY:GDDAddrSendRemote] message:@{@"action":@"get"} replyHandler:^(id<GDCMessage> message) {
    NSString *type = [message body][@"type"];
    NSString *strength = [message body][@"strength"];
    [self.connectivityTypeLable setText:type];
    [self.connectivityStrengthLable setText:[NSString stringWithFormat:@"%@",strength]];
  }];
}
@end
