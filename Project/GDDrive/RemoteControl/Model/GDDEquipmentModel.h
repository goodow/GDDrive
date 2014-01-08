//
//  GDDEquipmentModel.h
//  GDDrive
//
//  Created by 大黄 on 14-1-8.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDDEquipmentProtocol.h"

@interface GDDEquipmentModel : NSObject <GDDEquipmentProtocol>

@property (nonatomic, copy, readonly) NSString *equipmentID;

+ (GDDEquipmentModel *) sharedInstance;
- (void)updateEquipmentID:(NSString *)equipmentID;

@end
