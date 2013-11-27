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

UIKIT_EXTERN NSString *const hadDownloadKey;
@property (nonatomic, assign) BOOL hadDownload;
//判断文件本地是否已经存在
- (BOOL)isAlreadyPresentInTheLocalFileByData:(GDRCollaborativeMap *)map;
//下载文件
- (void)downloadByData:(GDRCollaborativeMap *)map
downloadProgressChanged:(DownloadProgressChangedBlock) changeBlock
     downloadFinished:(DownloadProgressFinishedBlock) finishedBlock
        downloadError:(DownloadErrorBlock) errorBlock;
//取消下载
- (void) cancelDownloadByData:(GDRCollaborativeMap *)map;
//获取已经下载完成的本地文件路径
-(NSString *)filePathOfHaveDownloadedByData:(GDRCollaborativeMap *)map;
//删除本地文件
- (void)deleteLocalHostFileByData:(GDRCollaborativeMap *)map;
//读取本地文件
- (NSData *)readFileByData:(GDRCollaborativeMap *)map;
@end
