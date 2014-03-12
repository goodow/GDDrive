//
//  Command.h
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>
/**GDDCommandForFirstStart
 * 命令接口，声明执行的操作
 */
@protocol GDDCommand <NSObject>
/**
 * 执行命令对应的操作
 */
-(void)execute;
@end