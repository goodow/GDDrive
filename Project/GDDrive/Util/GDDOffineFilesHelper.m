//
//  GDDOffineFilesHelper.m
//  GDDrive
//
//  Created by 大黄 on 13-11-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDOffineFilesHelper.h"

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

//解析文件路径根据数据
- (void)parseTheFilePathBasedOnTheData:(GDRCollaborativeMap *)map{
  if (!map) RNAssert(NO, @"解析文件路径根据数据 parseTheFilePathBasedOnTheData 传入数据不能为空");
  //获取路径
  //参数NSCachesDirectory要获取那种路径
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  self.workPath = paths[0];
  self.filePath = [self.workPath stringByAppendingPathComponent:[map get:@"blobKey"]];
  self.fileName = [map get:@"blobKey"];
  
}
//判断文件是否存在于本地
- (BOOL)isAlreadyPresentInTheLocalFileByData:(GDRCollaborativeMap *)map{
  [self parseTheFilePathBasedOnTheData:map];
  //创建文件管理器
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager changeCurrentDirectoryPath:[self.workPath stringByExpandingTildeInPath]];
  if (!self.filePath && ![self.filePath isEqualToString:@""]) {
    DLog(@"文件地址获取失败");
    return NO;
  }
  BOOL isExsit = [fileManager fileExistsAtPath:self.filePath];
  if (isExsit) {
    self.hadDownload = YES;
  }
  else
  {
    self.hadDownload = NO;
  }
  return isExsit;
}
-(NSString *)filePathOfHaveDownloadedByData:(GDRCollaborativeMap *)map{
  if ([self isAlreadyPresentInTheLocalFileByData:map]) {
    return self.filePath;
  }else{
    return nil;
  }
}
//开始下载
-(void)downloadByData:(GDRCollaborativeMap *)map downloadProgressChanged:(DownloadProgressChangedBlock) changeBlock downloadFinished:(DownloadProgressFinishedBlock) finishedBlock downloadError:(DownloadErrorBlock) errorBlock{
  //判断本地是否有该文件
  //如果有该文件。表示不需要下载了 直接return
  //如果没有该文件，我们将下载该文件
  if ([self isAlreadyPresentInTheLocalFileByData:map]) {
    finishedBlock();
    return;
  }
  [self parseTheFilePathBasedOnTheData:map];
  //开始创建路径并开始下载
  if (![map get:@"url"]) RNAssert(NO, @"下载文件url 获取失败");
  self.downloadOperation = [GDDRiveDelegate.downloadEngine downloadFatAssFileFrom:[map get:@"url"]
                                                                         toFile:self.filePath];
  [self.downloadOperation onDownloadProgressChanged:^(double progress) {
    changeBlock( progress*100.0 );
  }];
  __weak GDDOffineFilesHelper *weakSelf = self;
  [self.downloadOperation addCompletionHandler:^(MKNetworkOperation* completedRequest) {
    DLog(@"下载完成 %@", completedRequest);
    weakSelf.hadDownload = YES;
    finishedBlock();
    
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    DLog(@"%@", error);
    errorBlock(error);
  }];
}
//取消下载
- (void) cancelDownloadByData:(GDRCollaborativeMap *)map{
  [self.downloadOperation cancel];
  self.downloadOperation = nil;
  [self deleteLocalHostFileByData:map];
}

//读取文件
-(NSData *)readFileByData:(GDRCollaborativeMap *)map{
  [self parseTheFilePathBasedOnTheData:map];
  return [NSData dataWithContentsOfFile:self.filePath];
}
//删除文件
-(void)deleteLocalHostFileByData:(GDRCollaborativeMap *)map{
  [self parseTheFilePathBasedOnTheData:map];
  //删除待删除的文件
  NSFileManager *fileManager = [NSFileManager defaultManager];
  //更改到待操作的目录下
  [fileManager changeCurrentDirectoryPath:[self.workPath stringByExpandingTildeInPath]];
  //删除待删除的文件
  [fileManager removeItemAtPath:self.fileName error:nil];
  [self isAlreadyPresentInTheLocalFileByData:map];
}

@end
