//
//  GDDDownloadingState.m
//  GDDrive
//
//  Created by 大黄 on 13-12-9.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDDownloadingState.h"
#import "GDDOffineFilesHelper.h"
#import "GDDDownloadWorkContext.h"
#import "GDDFinishDownloadState.h"
#import "GDDPauseDownloadState.h"

@interface GDDDownloadingState()
@property (nonatomic, strong) GDDOffineFilesHelper *offineFilesHelper;
@property (nonatomic, strong) GDDDownloadWorkContext *work;
@end
@implementation GDDDownloadingState
-(id)init{
  if (self = [super init]) {
    _offineFilesHelper = [[GDDOffineFilesHelper alloc]init];
  }
  return self;
}

-(void)downloadWork:(GDDDownloadWorkContext *)work{
  self.work = work;
}
#pragma mark KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath
										 ofObject:(id)object
											 change:(NSDictionary *)change
											context:(void *)context {
  
  if ((__bridge id)context == self) {
    if ([keyPath isEqualToString:hadDownloadKey]){
      [self.work setState:(id<GDDDownloadState>)self.work.unDownloadState];
      [self.work triggerStateAction];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}
@end
