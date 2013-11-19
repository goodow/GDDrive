//
//  GDDFlickrEngine.m
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDFlickrEngine.h"

@implementation GDDFlickrEngine
-(void) imagesForTag:(NSString*) tag completionHandler:(FlickrImagesResponseBlock) imageURLBlock errorHandler:(MKNKErrorBlock) errorBlock {
  
  MKNetworkOperation *op = [self operationWithPath:@""];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      imageURLBlock(jsonObject[@"photos"][@"photo"]);
    }];
    
  } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
}

//-(NSString*) cacheDirectoryName {
//  
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//  NSString *documentsDirectory = paths[0];
//  NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"FlickrImages"];
//  return cacheDirectoryName;
//}

@end
