//
//  GDDMenuRootController.h
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSStackedViewControllerDecorate;

@interface GDDMenuRootController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) PSStackedViewControllerDecorate *stackedViewControllerDecorate;
@end
