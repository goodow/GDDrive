//
//  GDDFlickrEngine.h
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "MKNetworkEngine.h"

#define FLICKR_KEY @"210af0ac7c5dad997a19f7667e5779d3"
#define FLICKR_IMAGE_URL(__TAG__) [NSString stringWithFormat:@"services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=200&format=json&nojsoncallback=1", FLICKR_KEY, __TAG__]

@interface GDDFlickrEngine : MKNetworkEngine

typedef void (^FlickrImagesResponseBlock)(NSMutableArray* imageURLs);
//-(void) imagesForTag:(NSString*) tag completionHandler:(FlickrImagesResponseBlock) imageURLBlock errorHandler:(MKNKErrorBlock) errorBlock;
-(MKNetworkOperation*) downloadFatAssFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath;

@end
