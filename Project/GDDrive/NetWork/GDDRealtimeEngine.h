//
//  GDDRealtimeEngine.h
//  GDDrive
//
//  Created by 大黄 on 13-11-29.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^GDDRealtimeEngineResponseBlock)(NSDictionary* response);
typedef void (^GDDRealtimeEngineErrorBlock)(NSString *errorString , NSError *error);
@interface GDDRealtimeEngine : MKNetworkEngine

-(MKNetworkOperation *)loginWithUserName:(NSString *)userName
                                password:(NSString *)password
                       completionHandler:(GDDRealtimeEngineResponseBlock)completionBlock
                            errorHandler:(GDDRealtimeEngineErrorBlock) errorBlock;

@end
