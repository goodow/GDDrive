//
//  GDDUIBarButtonItemDelegate.h
//  GDDrive
//
//  Created by 大黄 on 13-10-31.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^GDDUIBarButtonItemClickBlock)(void);

@interface GDDUIBarButtonItem : UIBarButtonItem
-(id)initWithRootTitle:(NSString *)title withClick:(GDDUIBarButtonItemClickBlock)block;
-(void)addHistoryData:(NSObject *)obj pushTitleBySelectIndex:(NSInteger)index;
-(id)historyLastObjectAndRemoveIt;
@end

