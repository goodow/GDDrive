//
//  GDDUnDownloadState.m
//  GDDrive
//
//  Created by 大黄 on 13-12-9.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDUnDownloadState.h"
#import "GDDDownloadWorkContext.h"
#import "GDDWillDownloadState.h"
#import "GDDOffineFilesHelper.h"

@interface GDDUnDownloadState()
@property (nonatomic, strong) GDDDownloadWorkContext *work;
@end
@implementation GDDUnDownloadState
-(id)init{
  if (self = [super init]) {
    
  }
  return self;
}
-(void)downloadWork:(GDDDownloadWorkContext *)work{
  self.work = work;
  work.titleBlock(@"Download");
  work.enableBlock(YES);
  [work.offineFilesHelper isAlreadyPresentInTheLocalFileByData:work.map];
}
#pragma mark KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath
										 ofObject:(id)object
											 change:(NSDictionary *)change
											context:(void *)context {
  
  if ((__bridge id)context == self) {// Our notification, not our superclass’s
    if ([keyPath isEqualToString:hadDownloadKey]){
      if ([[change objectForKey:@"new"]boolValue]) {
        [self.work setState:(id<GDDDownloadState>)self.work.finishDowloadState];
        self.work.progressBlock(100.0f);
        [self.work triggerStateAction];
      }else{
        self.work.enableBlock(YES);
        [self.work setState:(id<GDDDownloadState>)self.work.willDownloadState];
        self.work.progressBlock(0.0f);
      }
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}
@end
