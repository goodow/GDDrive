//
//  GDDRemoteControlViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-2-14.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDRemoteControlViewController.h"
#import "GDDAddr.h"
#import "GDDBusProvider.h"
#import "GDDTouchVisualizer.h"
#import "UIImage+GDDEffects.h"

typedef enum {
  KEYCODE_BACK = 4,
  KEYCODE_DPAD_UP = 19,
  KEYCODE_DPAD_DOWN = 20,
  KEYCODE_DPAD_LEFT = 21,
  KEYCODE_DPAD_RIGHT = 22,
  KEYCODE_DPAD_CENTER = 23
} KEYCODE_DPAD;

@interface GDDRemoteControlViewController ()
@property (nonatomic, strong) IBOutlet UIView *touchView;
@property (nonatomic, strong) IBOutlet UIImageView *rightImageView;
@property (nonatomic, strong) IBOutlet UIImageView *leftImageView;
@property (nonatomic, strong) IBOutlet UIImageView *upImageView;
@property (nonatomic, strong) IBOutlet UIImageView *downImageView;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;

@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, strong) GDDTouchVisualizer *touchVisualizer;
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
  self.navigationItem.title = @"遥控器";
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"BACK" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
  
  //监听上下左右手势变化
  self.bus = [GDDBusProvider BUS];
  UISwipeGestureRecognizer *recognizer;
  recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
  [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
  [self.touchView addGestureRecognizer:recognizer];
  
  recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
  [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
  [self.touchView addGestureRecognizer:recognizer];
  
  recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
  [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
  [self.touchView addGestureRecognizer:recognizer];
  
  recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
  [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
  [self.touchView addGestureRecognizer:recognizer];
  
  //监听单击手势
  UITapGestureRecognizer *singleFinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
  singleFinger.numberOfTouchesRequired = 1;
  singleFinger.numberOfTapsRequired = 1;
  singleFinger.delegate = self;
  [self.touchView addGestureRecognizer:singleFinger];
  
  //界面效果
  [self.rightImageView setImage:[UIImage imageNamed:@"arrows.png"]];
  [self.leftImageView setImage:[UIImage image:[UIImage imageNamed:@"arrows.png"] rotation:UIImageOrientationDown]];
  [self.upImageView setImage:[UIImage image:[UIImage imageNamed:@"arrows.png"] rotation:UIImageOrientationLeft]];
  [self.downImageView setImage:[UIImage image:[UIImage imageNamed:@"arrows.png"] rotation:UIImageOrientationRight]];
  
  UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_arrows.png"]];
  backImageView.size = CGSizeMake(110, 110);
  UIImageView *homeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home.png"]];
  homeImageView.size = CGSizeMake(110, 110);
  [self.backButton addSubview:backImageView];
  [self.homeButton addSubview:homeImageView];
  
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.touchVisualizer = [GDDTouchVisualizer sharedTouchVisualizer];
  [self.touchVisualizer install:self.touchView];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.touchVisualizer remove];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}
//处理单指事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
  if (sender.numberOfTapsRequired == 1) {
    //单指单击
    NSLog(@"单指单击");
    [self.bus send:[GDDAddr INPUT_SIMULATE_KEYBOARD:GDDAddrSendRemote] message:@{@"key":[NSNumber numberWithInt:KEYCODE_DPAD_CENTER]} replyHandler:nil];
  }else if(sender.numberOfTapsRequired == 2){
    //单指双击
    NSLog(@"单指双击");
  }
}
//处理手指滑动事件
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
  
  if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
    
    NSLog(@"swipe down");
    [self.bus send:[GDDAddr INPUT_SIMULATE_KEYBOARD:GDDAddrSendRemote] message:@{@"key":[NSNumber numberWithInt:KEYCODE_DPAD_DOWN]} replyHandler:nil];
  }else if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
    
    NSLog(@"swipe up");
    [self.bus send:[GDDAddr INPUT_SIMULATE_KEYBOARD:GDDAddrSendRemote] message:@{@"key":[NSNumber numberWithInt:KEYCODE_DPAD_UP]} replyHandler:nil];
  }else if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
    
    NSLog(@"swipe left");
    [self.bus send:[GDDAddr INPUT_SIMULATE_KEYBOARD:GDDAddrSendRemote] message:@{@"key":[NSNumber numberWithInt:KEYCODE_DPAD_LEFT]} replyHandler:nil];
  }else if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
    NSLog(@"swipe right");
    [self.bus send:[GDDAddr INPUT_SIMULATE_KEYBOARD:GDDAddrSendRemote] message:@{@"key":[NSNumber numberWithInt:KEYCODE_DPAD_RIGHT]} replyHandler:nil];
  }
  
}

-(IBAction)handleBackAction:(id)sender{
  NSLog(@"遥控器 后退键");
  [self.bus send:[GDDAddr INPUT_SIMULATE_KEYBOARD:GDDAddrSendRemote] message:@{@"key":[NSNumber numberWithInt:KEYCODE_BACK]} replyHandler:nil];
}
-(IBAction)handleHomeAction:(id)sender{
  NSLog(@"遥控器 首页显示");
  [self.bus send:[GDDAddr HOME:GDDAddrSendRemote] message:@{@"":@""} replyHandler:nil];
}

@end
