//
//  GDDMainViewController_ipad.h
//  GDDrive
//
//  Created by 大黄 on 13-12-12.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDRealtimeProtocol.h"
#import "PSStackedViewDelegate.h"

@protocol GDDMainViewController_ipad <NSObject>

- (NSString *)interfaceDescription;
- (NSString *)realtimeLoadLocation;
- (NSString *)filesKey;
- (NSString *)foldersKey;
@end

@interface GDDMainViewController_ipad : UIViewController <GDDMainViewController_ipad,UITableViewDataSource,UITableViewDelegate,GDRealtimeProtocol,PSStackedViewDelegate>

-(void)resetIsControllerDeallocTag;

@end
