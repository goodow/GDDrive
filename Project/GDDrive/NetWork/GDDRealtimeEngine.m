//
//  GDDRealtimeEngine.m
//  GDDrive
//
//  Created by 大黄 on 13-11-29.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDRealtimeEngine.h"

@implementation GDDRealtimeEngine

-(MKNetworkOperation *)loginWithUserName:(NSString *)userName
                                password:(NSString *)password
                       completionHandler:(GDDRealtimeEngineResponseBlock)completionBlock
                            errorHandler:(GDDRealtimeEngineErrorBlock)errorBlock{
  
  MKNetworkOperation *operation = [self operationWithURLString:GDDRealtimeLoginURL(userName, password)
                                                        params:nil
                                                    httpMethod:@"post"];
  
  [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    DLog(@"%d", [completedOperation HTTPStatusCode]);
    DLog(@"%@", [completedOperation responseString]);
    if ([completedOperation HTTPStatusCode] == 204) {
      errorBlock(@"用户名密码错误",nil);
    }else{

      completionBlock([completedOperation responseJSON]);
    }
    
    
    
    
  } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    
    errorBlock(@"",error);
    
  }];
  
  [self enqueueOperation:operation];
  
  return operation;

}
@end
