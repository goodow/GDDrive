//
//  GDDEngine.m
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDEngine.h"

@implementation GDDEngine

-(MKNetworkOperation*) downloadFatAssFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath {
  
  MKNetworkOperation *op = [self operationWithURLString:remoteURL];
  
  [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                          append:YES]];
  
  [self enqueueOperation:op];
  return op;
}


@end
