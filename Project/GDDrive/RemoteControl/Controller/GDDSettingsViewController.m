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
@property (nonatomic, strong) GDDLocationTableViewController *locationTableViewController;
@property (nonatomic, strong) GDDInformationTableViewController *informationTableViewController;
@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsWifiHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsResolutionHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsScreenOffsetHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsAboutUsHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsLocationHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsInformationHandlerRegistration;
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
  self.swichSettingsWifiHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr SWITCH_SETTINGS_WIFI:GDDAddrReceive] handler:^(id<GDCMessage> message){
    [weakSelf settingsWifiAction:nil];
  }];
  self.swichSettingsResolutionHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_SETTINGS_RESOLUTION:GDDAddrReceive] handler:^(id <GDCMessage> message){
    [weakSelf resolutionAction:nil];
  }];
  self.swichSettingsScreenOffsetHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_SETTINGS_SCREEN_OFFSET:GDDAddrReceive] handler:^(id <GDCMessage> message){
    [weakSelf screenOffSetAction:nil];
  }];
  self.swichSettingsAboutUsHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_SETTINGS_ABOOUT_US:GDDAddrReceive] handler:^(id <GDCMessage> message){
    [weakSelf aboutUsAction:nil];
  }];
  self.swichSettingsLocationHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_SETTINGS_LOCATION:GDDAddrReceive] handler:^(id <GDCMessage> message){
    [weakSelf locationAction:nil];
  }];
  self.swichSettingsInformationHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_SETTINGS_INFORMATION:GDDAddrReceive] handler:^(id <GDCMessage> message){
  [weakSelf informationAction:nil];
  }];
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.swichSettingsWifiHandlerRegistration unregisterHandler];
  [self.swichSettingsResolutionHandlerRegistration unregisterHandler];
  [self.swichSettingsScreenOffsetHandlerRegistration unregisterHandler];
  [self.swichSettingsAboutUsHandlerRegistration unregisterHandler];
  [self.swichSettingsLocationHandlerRegistration unregisterHandler];
  [self.swichSettingsInformationHandlerRegistration unregisterHandler];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

@end
