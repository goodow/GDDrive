//
//  UIColor+GDDColorSchemes.h
//  GDDrive
//
//  Created by 大黄 on 13-11-27.
//  Copyright (c) 2013年 大黄. All rights reserved.
//
//  作用：解析color的16进制值，并提供改变view背景的方法

#import <UIKit/UIKit.h>

@interface UIColor (GDDColorSchemes)

+ (UIColor *)parseColorFromRGB:(NSString *)rgb;
+ (UIColor *)parseColorFromRGBA:(NSString *)rgb Alpha:(float)alpha;

@end
