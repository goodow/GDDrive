//
//  GDDEditableCellModel.h
//  GDDrive
//
//  Created by 大黄 on 14-3-28.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDDEditableCellModel : NSObject

@property (nonatomic, readonly, copy) NSArray *dataSource;
@property (nonatomic, readonly, copy) NSArray *selectedTagArray;

- (id)initWithDataSource:(NSArray *)dataSource;
- (void)setSelectedTagByIndex:(NSUInteger)index value:(BOOL)value;
- (BOOL)selectedTagByIndex:(NSUInteger)index;
- (void)setALLSelectedTagByValue:(BOOL)value;
@end
