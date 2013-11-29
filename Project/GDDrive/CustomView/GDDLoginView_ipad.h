//
//  GDDLoginView_ipad.h
//  GDDrive
//
//  Created by 大黄 on 13-12-2.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SetingBlock)(void);
@interface GDDLoginView_ipad : UIView

-(void)setViewStyle;
-(void)setClickBlock:(SetingBlock)block;
-(void)bindData;
@end
