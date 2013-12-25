//
//  GDDPlayPDFViewController_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-27.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDPlayPDFViewController_ipad.h"
#import "GDDOffineFilesHelper.h"

@interface GDDPlayPDFViewController_ipad () <ReaderViewControllerDelegate>
@property (nonatomic, strong) DismissReaderViewControllerBlock dismissReaderViewControllerBlock;


@end

@implementation GDDPlayPDFViewController_ipad

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
   [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - ReaderViewController delegate
-(void)dismissReaderViewController:(ReaderViewController *)viewController{
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    GDDRiveDelegate.window.clipsToBounds =YES;
    GDDRiveDelegate.window.frame =  CGRectMake(0,20,GDDRiveDelegate.window.frame.size.width,GDDRiveDelegate.window.frame.size.height-20);
  }
  self.dismissReaderViewControllerBlock(viewController);
}
@end
