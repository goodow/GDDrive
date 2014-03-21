//
//  GDDCommandForFirstStart.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForFirstStart.h"

@implementation GDDCommandForFirstStart
-(void)execute {
  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
  }
  else{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
  }
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    // 这里判断是否第一次
    [GDDPlistHelper createPlistMirror];
  }
}
@end
