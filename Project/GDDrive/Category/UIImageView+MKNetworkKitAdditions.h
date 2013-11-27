//
//  UIImageView+MKNetworkKitAdditions.h
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const float kFromCacheAnimationDuration;
extern const float kFreshLoadAnimationDuration;

@class MKNetworkEngine;
@class MKNetworkOperation;

@interface UIImageView (MKNetworkKitAdditions)
+(void) setDefaultEngine:(MKNetworkEngine*) engine;
-(MKNetworkOperation*) setImageFromURL:(NSURL*) url;
-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image;
-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image animation:(BOOL) yesOrNo;
-(MKNetworkOperation*) setImageFromURL:(NSURL*) url placeHolderImage:(UIImage*) image usingEngine:(MKNetworkEngine*) imageCacheEngine animation:(BOOL) yesOrNo;
-(void)cancelOperation;
@end
