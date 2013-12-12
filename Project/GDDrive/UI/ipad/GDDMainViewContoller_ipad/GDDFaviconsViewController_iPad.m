//
//  GDDFaviconsViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDFaviconsViewController_iPad.h"
#import "GDDUIBarButtonItem.h"
#import "GDDContentListCell_ipad.h"

@interface GDDFaviconsViewController_iPad ()
@end

@implementation GDDFaviconsViewController_iPad

-(void)viewDidLoad{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(NSString *)interfaceDescription{
  return @"我的收藏";
}
-(NSString *)realtimeLoadLocation{
  return [NSString stringWithFormat:@"%@/%@/%@",GDDConfigPlist(@"documentId"),GDDConfigPlist(@"userId"),GDDConfigPlist(@"favorites")];
}
-(NSString *)filesKey{
  return @"files";
}
-(NSString *)foldersKey{
  return @"folders";
}

@end
