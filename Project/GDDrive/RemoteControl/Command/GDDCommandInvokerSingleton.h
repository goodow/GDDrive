//
//  CommandInvokerSingleton.h
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDDCommandInvokerSingleton : NSObject
+ (GDDCommandInvokerSingleton *) sharedInstance;
-(void)runCommandWithCommandObject:(id)commandObject;
@end
