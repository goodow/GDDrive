//
//  GDDPlistHelper.h
//  GDDrive
//
//  Created by 大黄 on 13-11-29.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDDPlistHelper : NSObject
+ (GDDPlistHelper *) sharedInstance;
+ (void)createPlistMirror;
-(NSString *)objectFromPlistKey:(NSString *)key;
-(void)setInPlistObject:(id)object forKey:(id)key;

@end
