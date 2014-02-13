//
//  GDDSideViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-2-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDSideViewController.h"
#import "GDDAddr.h"
#import "GDDBusProvider.h"

@interface GDDSideViewController ()
@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsWifiHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsResolutionHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsScreenOffsetHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichSettingsAboutUsHandlerRegistration;
@end

@implementation GDDSideViewController

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
  // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  __weak GDDSideViewController *weakSelf = self;
  self.swichSettingsWifiHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr SWITCH_SETTINGS_WIFI:GDDAddrReceive] handler:^(id<GDCMessage> message){
    [weakSelf sideWifiAction:nil];
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
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.swichSettingsWifiHandlerRegistration unregisterHandler];
  [self.swichSettingsResolutionHandlerRegistration unregisterHandler];
  [self.swichSettingsScreenOffsetHandlerRegistration unregisterHandler];
  [self.swichSettingsAboutUsHandlerRegistration unregisterHandler];
  
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -IBAction
-(IBAction)sideWifiAction:(id)sender{
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

@end
