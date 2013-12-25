//
//  GDDBus.h
//  GDDrive
//
//  Created by 大黄 on 13-12-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDChannel.h"

@interface GDDBus : NSObject
+ (GDDBus *) sharedInstance;
- (id<GDCBus>)bus;
@end
