//
//  GDDEngine.h
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface GDDEngine : MKNetworkEngine

-(MKNetworkOperation*) downloadFatAssFileFrom:(NSString*) remoteURL toFile:(NSString*) filePath;

@end
