//
//  ColorUtils.m
//  mapper_ios
//
//  Created by zhaoqing huang on 12-1-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GDDColorUtils.h"


#define RGB_N(v) (v) / 255.0f

@implementation GDDColorUtils

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


+ (UIColor *)parseColorFromRGB:(NSString *)rgb{
    return [GDDColorUtils parseColorFromRGBA:rgb Alpha:1];
}

+ (UIColor *)parseColorFromRGBA:(NSString *)rgb Alpha:(float)alpha{
    const char *string = [rgb UTF8String];
    
    if (!strncmp(string, "#", 1)) {
		const char *hexString = string + 1;
		
		if (strlen(hexString) != 6) {
			return [UIColor blackColor];
		}
        
		else {
			char r[3], g[3], b[3];
			r[2] = g[2] = b[2] = '\0';
			
			strncpy(r, hexString, 2);
			strncpy(g, hexString + 2, 2);
			strncpy(b, hexString + 4, 2);
			
            return [UIColor colorWithRed:RGB_N(strtol(r, NULL, 16))
                                   green:RGB_N(strtol(g, NULL, 16))
                                    blue:RGB_N(strtol(b, NULL, 16))
                                   alpha:((alpha>1 || alpha<0) ? 1 : alpha)];
		}
	}
    return [UIColor blackColor];
}

@end
