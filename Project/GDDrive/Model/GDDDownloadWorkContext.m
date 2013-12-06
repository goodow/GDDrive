//
//  GDDDownloadWorkContext.m
//  GDDrive
//
//  Created by 大黄 on 13-12-10.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDDownloadWorkContext.h"
#import "GDDUnDownloadState.h"
#import "GDDUnDownloadState.h"
#import "GDDWillDownloadState.h"
#import "GDDDownloadingState.h"
#import "GDDPauseDownloadState.h"
#import "GDDFinishDownloadState.h"
#import "GDDOffineFilesHelper.h"

@interface GDDDownloadWorkContext ()
@property (nonatomic, strong) id <GDDDownloadState> currentState;
@property (nonatomic, strong, readwrite) GDRCollaborativeMap *map;

@property (nonatomic, strong, readwrite) GDDUnDownloadState *unDownloadState;
@property (nonatomic, strong, readwrite) GDDWillDownloadState *willDownloadState;
@property (nonatomic, strong, readwrite) GDDDownloadingState *downloadingState;
@property (nonatomic, strong, readwrite) GDDPauseDownloadState *pauseDownloadState;
@property (nonatomic, strong, readwrite) GDDFinishDownloadState *finishDowloadState;

@property (nonatomic, strong, readwrite) GDDOffineFilesHelper *offineFilesHelper;
@property (nonatomic, strong, readwrite) GDDDownloadProgressChangedBlock progressBlock;
@property (nonatomic, strong, readwrite) GDDDownloadButtonTitleChangedBlock titleBlock;
@property (nonatomic, strong, readwrite) GDDDownloadButtonEnableChangedBlock enableBlock;
@end

@implementation GDDDownloadWorkContext
-(id)init{
  if (self = [super init]) {
    _unDownloadState = [[GDDUnDownloadState alloc]init];
    _willDownloadState = [[GDDWillDownloadState alloc]init];
    _downloadingState = [[GDDDownloadingState alloc]init];
    _pauseDownloadState = [[GDDPauseDownloadState alloc]init];
    _finishDowloadState = [[GDDFinishDownloadState alloc]init];
    
    _offineFilesHelper = [[GDDOffineFilesHelper alloc]init];
    
    _currentState = _unDownloadState;
    [_offineFilesHelper addObserver:(id)_currentState
                         forKeyPath:hadDownloadKey
                            options:NSKeyValueObservingOptionNew
                            context:(__bridge void*)(id)_currentState];
    
  }
  return self;
}

-(void)bindWithDataBean:(GDRCollaborativeMap *)aMap
      TitleChangedBlock:(GDDDownloadButtonTitleChangedBlock)titleBlock
     EnableChangedBlock:(GDDDownloadButtonEnableChangedBlock)enableBlock
   ProgressChangedBlock:(GDDDownloadProgressChangedBlock) progressBlock{
  
  //如果正在下载的状态，将不会重置状态为 unDownloadState
  if (![self.currentState isKindOfClass:[GDDDownloadingState class]]) {
    self.titleBlock = titleBlock;
    self.enableBlock = enableBlock;
    self.progressBlock = progressBlock;
    self.map = aMap;
    [self setState:(id<GDDDownloadState>)self.unDownloadState];
    [self triggerStateAction];
  }
  
}

-(void)setState:(id<GDDDownloadState>)state{
  [self.offineFilesHelper removeObserver:(id)self.currentState forKeyPath:hadDownloadKey];
  [self.offineFilesHelper addObserver:(id)state
                           forKeyPath:hadDownloadKey
                              options:NSKeyValueObservingOptionNew
                              context:(__bridge void*)(id)state];
  self.currentState = state;
}
-(void)triggerStateAction{
  [self.currentState downloadWork:self];
}
-(void)interruptHandling{
  if ([self.currentState isKindOfClass:[self.downloadingState class]]) {
    [self triggerStateAction];
  }
}

@end
