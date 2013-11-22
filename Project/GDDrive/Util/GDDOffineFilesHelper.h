//
//  GDDOffineFilesHelper.h
//  GDDrive
//
//  Created by 大黄 on 13-11-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^DownloadProgressChangedBlock)(double progress);
typedef void (^DownloadProgressFinishedBlock)(void);
typedef void (^DownloadErrorBlock)(NSError* error);

@interface GDDOffineFilesHelper : NSObject

-(void)downloadByData:(GDRCollaborativeMap *)map
downloadProgressChanged:(DownloadProgressChangedBlock) changeBlock
     downloadFinished:(DownloadProgressFinishedBlock) finishedBlock
        downloadError:(DownloadErrorBlock) errorBlock;
- (void) cancelDownload;
@end
