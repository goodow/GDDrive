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
