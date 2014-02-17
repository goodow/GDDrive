//
//  GDDTouchVisualizer.h
//  GDDrive
//
//  Created by 大黄 on 14-2-19.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDDTouchVisualizer : NSObject
+ (GDDTouchVisualizer *)sharedTouchVisualizer;
-(void)install:(UIView *)view;
-(void)remove;
@end
