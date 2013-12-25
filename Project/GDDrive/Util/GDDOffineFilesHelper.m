//
//  GDDOffineFilesHelper.m
//  GDDrive
//
//  Created by 大黄 on 13-11-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDOffineFilesHelper.h"
#import "GDDGenreDictionary.h"
@interface GDDOffineFilesHelper()

@property (nonatomic, strong) MKNetworkOperation *downloadOperation;
@property (nonatomic, strong) NSString *workPath;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileName;

@end



@implementation GDDOffineFilesHelper
NSString *const hadDownloadKey = @"hadDownload";
-(id)init{
  if (self = [super init]) {
    _hadDownload = NO;
  }
  return self;
}


@end
