//
//  GDDDownloadWorkContext.h
//  GDDrive
//
//  Created by 大黄 on 13-12-10.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDDDownloadState.h"
@class GDDUnDownloadState;
@class GDDWillDownloadState;
@class GDDDownloadingState;
@class GDDPauseDownloadState;
@class GDDFinishDownloadState;
@class GDDOffineFilesHelper;

typedef void (^GDDDownloadProgressChangedBlock)(double progress);
typedef void (^GDDDownloadButtonTitleChangedBlock)(NSString *title);
typedef void (^GDDDownloadButtonEnableChangedBlock)(BOOL enable);

@interface GDDDownloadWorkContext : NSObject
@property (nonatomic, strong, readonly) GDRCollaborativeMap *map;
@property (nonatomic, strong, readonly) GDDOffineFilesHelper *offineFilesHelper;

@property (nonatomic, strong, readonly) GDDUnDownloadState *unDownloadState;
@property (nonatomic, strong, readonly) GDDWillDownloadState *willDownloadState;
@property (nonatomic, strong, readonly) GDDDownloadingState *downloadingState;
@property (nonatomic, strong, readonly) GDDPauseDownloadState *pauseDownloadState;
@property (nonatomic, strong, readonly) GDDFinishDownloadState *finishDowloadState;

@property (nonatomic, strong, readonly) GDDDownloadProgressChangedBlock progressBlock;
@property (nonatomic, strong, readonly) GDDDownloadButtonTitleChangedBlock titleBlock;
@property (nonatomic, strong, readonly) GDDDownloadButtonEnableChangedBlock enableBlock;

-(void)bindWithDataBean:(GDRCollaborativeMap *)aMap
      TitleChangedBlock:(GDDDownloadButtonTitleChangedBlock)titleBlock
     EnableChangedBlock:(GDDDownloadButtonEnableChangedBlock)enableBlock
   ProgressChangedBlock:(GDDDownloadProgressChangedBlock) progressBlock;
-(void)setState:(id<GDDDownloadState>)state;
-(void)triggerStateAction;
-(void)interruptHandling;
@end
