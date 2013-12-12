//
//  GDDClassViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDClassViewController_iPad.h"
@interface GDDClassViewController_iPad ()

@end

@implementation GDDClassViewController_iPad

-(void)viewDidLoad{
  [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(NSString *)interfaceDescription{
  return @"我的课程";
}
-(NSString *)realtimeLoadLocation{
  return [NSString stringWithFormat:@"%@/%@/%@",GDDConfigPlist(@"documentId"),GDDConfigPlist(@"userId"),GDDConfigPlist(@"lesson")];
}
-(NSString *)filesKey{
  return @"files";
}
-(NSString *)foldersKey{
  return @"folders";
}

@end
