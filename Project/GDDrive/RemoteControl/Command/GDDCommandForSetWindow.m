//
//  GDDCommandForSetWindow.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForSetWindow.h"
#import "AppDelegate.h"

@implementation GDDCommandForSetWindow
-(void)execute {
  UIApplication *application = [UIApplication sharedApplication];
  if (application.statusBarOrientation == UIInterfaceOrientationPortrait) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,20,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if (application.statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height - 20);
  }else if(application.statusBarOrientation == UIInterfaceOrientationLandscapeLeft ) {
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(20,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }else if (application.statusBarOrientation == UIInterfaceOrientationLandscapeRight){
    GDDRemoteControlDelegate.window.clipsToBounds =YES;
    GDDRemoteControlDelegate.window.frame =  CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width - 20,[[UIScreen mainScreen]bounds].size.height);
  }
}
@end
