//
//  GDDFinishDownloadState.m
//  GDDrive
//
//  Created by 大黄 on 13-12-9.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDFinishDownloadState.h"
#import "GDDOffineFilesHelper.h"
#import "GDDDownloadWorkContext.h"

@interface GDDFinishDownloadState()
@property (nonatomic, strong) GDDDownloadWorkContext *work;
@end
@implementation GDDFinishDownloadState

-(void)downloadWork:(GDDDownloadWorkContext *)work{
  self.work = work;
  
  self.work.titleBlock(@"Finish");
  self.work.enableBlock(NO);
}

#pragma mark KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath
										 ofObject:(id)object
											 change:(NSDictionary *)change
											context:(void *)context {
  
  if ((__bridge id)context == self) {// Our notification, not our superclass’s
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}
@end
