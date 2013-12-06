//
//  GDDWillDownloadState.m
//  GDDrive
//
//  Created by 大黄 on 13-12-9.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDWillDownloadState.h"
#import "GDDOffineFilesHelper.h"
#import "GDDDownloadWorkContext.h"
#import "GDDFinishDownloadState.h"

@interface GDDWillDownloadState()
@property (nonatomic, strong) GDDDownloadWorkContext *work;
@end
@implementation GDDWillDownloadState

-(id)init{
  if (self = [super init]) {

  }
  return self;
}

-(void)downloadWork:(GDDDownloadWorkContext *)work{
  self.work = work;
  self.work.titleBlock(@"Loading");
  self.work.enableBlock(YES);
  [self beginDownload];
}
-(void)beginDownload{
  [self.work.offineFilesHelper downloadByData:self.work.map downloadProgressChanged:^(double progress) {
    self.work.progressBlock(progress);
  } downloadFinished:^{
    //    DLog(@"kvo 监听 文件下载完成 显示变更为完成");å
    [self.work setState:(id<GDDDownloadState>)self.work.finishDowloadState];
    self.work.progressBlock(100.0f);
    [self.work triggerStateAction];
  } downloadError:^(NSError *error) {
    DLog(@"离线文件下载错误了:%@",error);
  }];
}

#pragma mark KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath
										 ofObject:(id)object
											 change:(NSDictionary *)change
											context:(void *)context {
  if ((__bridge id)context == self) {
    if ([keyPath isEqualToString:hadDownloadKey]){
      self.work.titleBlock(@"Pause");
      self.work.enableBlock(YES);
      [self.work setState:(id<GDDDownloadState>)self.work.downloadingState];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

@end
