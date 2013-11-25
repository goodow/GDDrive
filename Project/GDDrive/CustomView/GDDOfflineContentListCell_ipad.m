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

@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) MKNetworkOperation *downloadOperation;
@property (nonatomic, strong) GDDOffineFilesHelper *offineFilesHelper;
@property (nonatomic, assign) BOOL isDownloading;

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
    _isDownloading = NO;
    _offineFilesHelper = [[GDDOffineFilesHelper alloc]init];
    [_offineFilesHelper addObserver:self
                             forKeyPath:hadDownloadKey
                                options:NSKeyValueObservingOptionNew
                                context:(__bridge void*)self];
  }
  return self;
}
-(void)removeAllObserver{
  [self.offineFilesHelper removeObserver:self forKeyPath:hadDownloadKey];
}
-(void)bindWithDataBean:(GDRCollaborativeMap *)aMap{
  [super bindWithDataBean:aMap];
  
  [self setDownloadButtonWithDataBean:aMap];
}
-(IBAction)contentMessageListener:(id)sender{
  [self cancelDownLoad];
  [super contentMessageListener:sender];
}
-(void)setDownloadButtonWithDataBean:(GDRCollaborativeMap *)aMap{
  [self.offineFilesHelper isAlreadyPresentInTheLocalFileByData:aMap];
}
-(IBAction)onCircularProgressViewListener:(id)sender{
  //开启和暂停下载 当下载完成时 事件会屏蔽 按钮自动隐藏
  if (self.isDownloading) {
    //暂停下载
    [self pauseDownLoad];
    self.isDownloading = NO;
  }else{
    //开始下载
    [self beginDownload];
    self.isDownloading = YES;
    [self.downloadButton setTitle:@"Pause" forState:UIControlStateNormal];
  }
  
}
-(void)beginDownload{
  [self.offineFilesHelper downloadByData:self.map downloadProgressChanged:^(double progress) {
    [self.progressView setProgress:progress/100.0f animated:YES];
  } downloadFinished:^{
    self.isDownloading = NO;
  } downloadError:^(NSError *error) {
    DLog(@"离线文件下载错误了");
  }];
}
-(void)cancelDownLoad{
  if (self.isDownloading) {
    [self.offineFilesHelper cancelDownloadByData:self.map];
    self.isDownloading = NO;
  }
}
-(void)pauseDownLoad{
  //目前没有断点续传，这里我们认为是直接取消了下载，下次重新下载
  [self cancelDownLoad];
}
#pragma mark KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath
										 ofObject:(id)object
											 change:(NSDictionary *)change
											context:(void *)context {
  
  if ((__bridge id)context == self) {// Our notification, not our superclass’s
    if ([keyPath isEqualToString:hadDownloadKey]){
      DLog(@"kvo 监听 文件已经下载");
      if ([[change objectForKey:@"new"]boolValue]) {
        if (self.isDownloading) {
          [self.downloadButton setTitle:@"Pause" forState:UIControlStateNormal];
          [self.downloadButton setEnabled:YES];
        }else{
          [self.downloadButton setTitle:@"Finish" forState:UIControlStateNormal];
          [self.downloadButton setEnabled:NO];
          [self.progressView setProgress:1.0f animated:YES];
        }
      }else{
        [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        [self.downloadButton setEnabled:YES];
        [self.progressView setProgress:0.0f animated:YES];
      }
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
