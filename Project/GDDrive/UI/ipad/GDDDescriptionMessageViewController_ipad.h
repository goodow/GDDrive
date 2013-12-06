//
//  GDDDescriptionMessageViewController.h
//  GDDrive
//
//  Created by 大黄 on 13-11-12.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CompletionBlock)(BOOL finished);

@interface GDDDescriptionMessageViewController_ipad : UIViewController
- (void)presentViewControllerCompletion:(CompletionBlock)completion;
- (void)dismissViewControllerCompletion:(CompletionBlock)completion;
- (void)bindWithDataBean:(GDRCollaborativeMap *)map;
@end
