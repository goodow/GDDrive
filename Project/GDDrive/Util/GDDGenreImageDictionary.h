//
//  GDDGenreImageDictionary.h
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDDGenreImageDictionary : NSObject
+ (GDDGenreImageDictionary *) sharedInstance;
-(NSString *)imageNameByKey:(NSString *)key;
-(NSString *)tinyImageNameByKey:(NSString *)key;
-(NSString *)largeImageNameByKey:(NSString *)key;
@end
