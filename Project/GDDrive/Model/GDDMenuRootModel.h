//
//  GDDMenuRootModel.h
//  GDDrive
//
//  Created by 大黄 on 13-11-15.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDDMenuRootModel : NSObject

-(id)initWithIcons:(NSArray *)aIcons labels:(NSArray *)aLabels;
-(NSInteger)count;
-(void)setLabelWithIndex:(NSInteger)index;
-(void)setIconWithIndex:(NSInteger)index;
@end
