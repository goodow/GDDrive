//
//  GDDRemoteControlViewController.m
//  GDDrive
//
//  Created by 大黄 on 13-12-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDRemoteControlViewController.h"
#import "GDDBus.h"

typedef void(^GDDBusHandlerBlock)(id<GDCMessage> message);

@interface GDDRemoteControlViewController ()

@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, strong) GDDBusHandlerBlock handlerBlock;

@property (nonatomic, weak) IBOutlet UISlider *volumeSlider;
@property (nonatomic, weak) IBOutlet UISlider *brightnessSlider;


- (IBAction)actionSliderVolume:(id)sender;
- (IBAction)actionSliderBrightness:(id)sender;
- (IBAction)actionMuteListener:(id)sender;
- (IBAction)actionShutdownListener:(id)sender;
- (IBAction)actionReturnListener:(id)sender;

@end

@implementation GDDRemoteControlViewController

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
  //设置扫描
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setSize:CGSizeMake(100, 40)];
  [button setTitle:@"正在扫描" forState:UIControlStateNormal];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(selectorEquipmentListener:) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.titleView = button;
  
  __weak GDDRemoteControlViewController *weakSelf = self;
  self.bus = [[GDDBus sharedInstance]bus];
  self.handlerBlock = ^(id<GDCMessage> message) {
    [weakSelf handlerEventBusOpened:[weakSelf bus]];
  };
  [self.bus registerHandler:[GDCBus LOCAL_ON_OPEN] handler:self.handlerBlock];
  
  //  [[GDDBus sharedInstance]bus] unregisterHandler:<#(NSString *)#> handler:<#(id)#>
}

//--- # 调节音量 address: sid.drive.settings.audio
//mute: true # 静音
//volume: 0.5 # 设置音量的大小 [0.0,1.0]
//range: -0.3 # 音量的增幅大小 [-1.0,1.0]

-(void)handlerEventBusOpened:(id<GDCBus>) bus {
  //  [bus registerHandler:@"hsid.drive.settings.audio" handler:^(id<GDCMessage> message) {
  //    NSMutableDictionary *body = [message body];
  //    NSLog(@"%@",body);
  //
  //    NSDictionary *msg = @{@"volume": @0.6};
  //    [message reply:msg replyHandler:^(id<GDCMessage> message) {
  //      NSMutableDictionary *body = [message body];
  //      NSLog(@"%@",body);
  //    }];
  //  }];
  //
  //  [bus send:@"hsid.drive.settings.audio" message:@{@"volume": @0.8} replyHandler:^(id<GDCMessage> message) {
  //    NSMutableDictionary *body = [message body];
  //    NSLog(@"%@",body);
  //    [message reply:@{@"volume": @0.8}];
  //  }];
  
  //  [bus publish:@"hsid.drive.settings.audio" message:@{@"volume": @0.8}];
  
  [bus send:@"hsid.drive.settings.audio" message:@{@"volume": @0.8} replyHandler:nil];
  [bus send:@"hsid.drive.control" message:@{@"brightness": @0.2} replyHandler:nil];

  
}



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
-(IBAction)selectorEquipmentListener:(id)sender{
  DLog(@"---");
}

- (IBAction)actionSliderVolume:(id)sender{
  [self.bus send:@"hsid.drive.settings.audio" message:@{@"volume": [NSNumber numberWithFloat:[self.volumeSlider value]]} replyHandler:nil];
  
  //  NSDictionary *d = @{@"aaa": @"111"};
  //  NSString *xxx=  d[@"aaa"];
  
}
- (IBAction)actionSliderBrightness:(id)sender{
  [self.bus send:@"hsid.drive.control" message:@{@"brightness": [NSNumber numberWithFloat:[self.brightnessSlider value]]} replyHandler:nil];
}

- (IBAction)actionMuteListener:(id)sender{
  [self.bus send:@"hsid.drive.settings.audio" message:@{@"mute": @YES} replyHandler:nil];
}
- (IBAction)actionShutdownListener:(id)sender{
  [self.bus send:@"hsid.drive.control" message:@{@"shutdown": @YES} replyHandler:nil];
}
- (IBAction)actionReturnListener:(id)sender{
  [self.bus send:@"hsid.drive.control" message:@{@"return": @YES} replyHandler:nil];
}
#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleDefault;
}

//- (BOOL)prefersStatusBarHidden
//{
//  return _isFullScreen;
//}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
  return UIStatusBarAnimationSlide;
}
@end
