//
//  GDDLoginMessageModel.h
//  GDDrive
//
//  Created by 大黄 on 13-12-2.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "BaseModel.h"

@interface GDDLoginMessageModel : BaseModel
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *displayName;
+ (GDDLoginMessageModel *) sharedInstance;
-(void)bindData;
-(void)removeData;
@end
