//
//  GDDRealtimeDataToViewController.h
//  GDDrive
//
//  Created by 大黄 on 13-11-7.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDRealtimeProtocol.h"

@interface GDDRealtimeDataToViewController : NSObject <GDRealtimeProtocol>

-(id)initWithObjectsAndKeys:(id)objectsAndKeys, ... ;

@end
