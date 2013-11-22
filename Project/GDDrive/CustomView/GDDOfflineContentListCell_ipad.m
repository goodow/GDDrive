//
//  GDDOfflineContentListCell_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-22.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDOfflineContentListCell_ipad.h"
#import "GDDOffineFilesHelper.h"

@interface GDDOfflineContentListCell_ipad()

@property (nonatomic, strong) MKNetworkOperation *downloadOperation;
@property (nonatomic, strong) GDDOffineFilesHelper *offineFilesHelper;
@property (nonatomic, assign) BOOL isDownload;

-(IBAction)onCircularProgressViewListener:(id)sender;
@end
@implementation GDDOfflineContentListCell_ipad

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
  if (self = [super initWithCoder:aDecoder]) {
    _isDownload = NO;
  }
  return self;
}
-(IBAction)onCircularProgressViewListener:(id)sender{
  
  NSLog(@"开启和暂停下载 当下载完成时 事件会屏蔽 按钮自动隐藏");
  if (self.isDownload) {
    //暂停下载
    [self pauseDownLoad];
    self.isDownload = NO;
  }else{
    //开始下载
    [self beginDownload];
    self.isDownload = YES;
  }
  
}
-(void)beginDownload{
  
  self.offineFilesHelper = [[GDDOffineFilesHelper alloc]init];
  [self.offineFilesHelper downloadByData:self.map downloadProgressChanged:^(double progress) {
    
  } downloadFinished:^{
    
  } downloadError:^(NSError *error) {
    
  }];
  
//  //判断本地是否有该文件
//  //如果有该文件。表示不需要下载了
//  //如果没有该文件，我们将下载该文件
//  //---------------------------------------------------------------------------------------------
//  //创建文件管理器
//  NSFileManager *fileManager = [NSFileManager defaultManager];
//  //获取路径
//  //参数NSCachesDirectory要获取那种路径
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//  NSString *cachesDirectory = paths[0];
//  NSString *str = [cachesDirectory stringByAppendingPathComponent:[self.map get:@"blobKey"]];
//  NSLog(@"str:%@",str);
//  BOOL isExsit = [fileManager fileExistsAtPath:str];
//  if (isExsit) {
//    DLog(@"文件存在");
//    return;
//  }
//  else
//  {
//    DLog(@"文件不存在 准备开始下载");
//  }
//  //开始创建路径并开始下载
//  if (![self.map get:@"blobKey"]) RNAssert(NO, @"下载文件名获取失败");
//  NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:[self.map get:@"blobKey"]];
//  if (![self.map get:@"url"]) RNAssert(NO, @"下载文件url 获取失败");
//  self.downloadOperation = [GDDRiveDelegate.flickrEngine downloadFatAssFileFrom:[self.map get:@"url"]
//                                                                         toFile:downloadPath];
//  [self.downloadOperation onDownloadProgressChanged:^(double progress) {
//    DLog(@"%.2f", progress*100.0);
//  }];
//  
//  [self.downloadOperation addCompletionHandler:^(MKNetworkOperation* completedRequest) {
//    NSLog(@"下载完成");
//    DLog(@"%@", completedRequest);
//    
//  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
//    DLog(@"%@", error);
//  }];
}
-(void)cancelDownLoad{
  
}
-(void)pauseDownLoad{
  
}
#pragma mark KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath
										 ofObject:(id)object
											 change:(NSDictionary *)change
											context:(void *)context {
  
  if ((__bridge id)context == self) {// Our notification, not our superclass’s
    if ([keyPath isEqualToString:isControllerDealloc]) {
      // 外部控制器, 已经被释放了, 在这里释放cell占用的资源
      NSLog(@"kvo 监听");
      [object removeObserver:self forKeyPath:isControllerDealloc];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
