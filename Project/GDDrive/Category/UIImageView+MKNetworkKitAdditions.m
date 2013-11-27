//
//  UIImageView+MKNetworkKitAdditions.m
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "UIImageView+MKNetworkKitAdditions.h"

#import "MKNetworkEngine.h"

#import <objc/runtime.h>

static MKNetworkEngine *DefaultEngine;
static char imageFetchOperationKey;

const float kFromCacheAnimationDuration = 0.1f;
const float kFreshLoadAnimationDuration = 0.35f;

@interface UIImageView (/*Private Methods*/)
@property (strong, nonatomic) MKNetworkOperation *imageFetchOperation;
@end

@implementation UIImageView (MKNetworkKitAdditions)

-(MKNetworkOperation*) imageFetchOperation {
  
  return (MKNetworkOperation*) objc_getAssociatedObject(self, &imageFetchOperationKey);
}

-(void) setImageFetchOperation:(MKNetworkOperation *)imageFetchOperation {
  
  objc_setAssociatedObject(self, &imageFetchOperationKey, imageFetchOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) setDefaultEngine:(MKNetworkEngine*) engine {
  
  DefaultEngine = engine;
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url {
  
  return [self setImageFromURL:url placeHolderImage:nil];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image {
  
  return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:YES];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image animation:(BOOL) yesOrNo {
  
  return [self setImageFromURL:url placeHolderImage:image usingEngine:DefaultEngine animation:yesOrNo];
}

-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image usingEngine:(MKNetworkEngine*) imageCacheEngine animation:(BOOL) animation {
  
  if(image) self.image = image;
  [self.imageFetchOperation cancel];
  if(!imageCacheEngine) imageCacheEngine = DefaultEngine;
  if(imageCacheEngine) {
    self.imageFetchOperation = [imageCacheEngine imageAtURL:url
                                          completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                            if(animation) {
                                              [UIView transitionWithView:self.superview
                                                                duration:isInCache?kFromCacheAnimationDuration:kFreshLoadAnimationDuration
                                                                 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                                              animations:^{
                                                                self.image = fetchedImage;
                                                              } completion:nil];
                                            } else {
                                              self.image = fetchedImage;
                                            }
                                            
                                          } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                                            DLog(@"%@", error);
                                          }];
  } else {
    DLog(@"No default engine found and imageCacheEngine parameter is null")
  }
  
  return self.imageFetchOperation;
}
-(void)cancelOperation{
  [self.imageFetchOperation cancel];
}
@end
