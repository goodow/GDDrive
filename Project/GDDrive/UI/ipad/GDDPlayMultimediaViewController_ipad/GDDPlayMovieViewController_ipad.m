//
//  GDDPlayMovieViewController_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-27.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDPlayMovieViewController_ipad.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GDDOffineFilesHelper.h"

@interface GDDPlayMovieViewController_ipad ()
@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerViewController;

@end

@implementation GDDPlayMovieViewController_ipad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

-(id)init{
  if (self = [super init]) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//  GDDRiveDelegate.window.frame =  CGRectMake(0,20,GDDRiveDelegate.window.frame.size.width,GDDRiveDelegate.window.frame.size.height+20);
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) playVideoFinished:(NSNotification *)theNotification//当点击Done按键或者播放完毕时调用此函数
{
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    GDDRiveDelegate.window.clipsToBounds =YES;
    GDDRiveDelegate.window.frame =  CGRectMake(0,20,GDDRiveDelegate.window.frame.size.width,GDDRiveDelegate.window.frame.size.height-20);
  }

  [self dismissViewControllerAnimated:YES completion:^{
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [self.moviePlayerViewController.view removeFromSuperview];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
      GDDRiveDelegate.window.clipsToBounds =YES;
      GDDRiveDelegate.window.frame =  CGRectMake(0,20,GDDRiveDelegate.window.frame.size.width,GDDRiveDelegate.window.frame.size.height-20);
    }

  }];


}
@end
