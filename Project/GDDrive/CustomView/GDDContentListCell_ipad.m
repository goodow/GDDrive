//
//  GDDContentListCell_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-19.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDContentListCell_ipad.h"
#import "GDDDescriptionMessageViewController_ipad.h"
#import "Boolean.h"
#import "GDDGenreDictionary.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "GDDMainViewController_ipad.h"

@interface GDDContentListCell_ipad()

@property (nonatomic, weak) IBOutlet UIImageView *contentListImageView;
@property (nonatomic, weak) IBOutlet UILabel *contentListLabel;
@property (nonatomic, strong, readwrite) GDDDescriptionMessageViewController_ipad *messageViewController;

@end
@implementation GDDContentListCell_ipad
-(id)initWithCoder:(NSCoder *)aDecoder{
  if (self = [super initWithCoder:aDecoder]) {
    
  }
  return self;
}
-(void)setLabel:(NSString *)text{
  [self.contentListLabel setText:text];
}
-(void)setContentType:(NSString *)aContentType{
  [self setIconImage:aContentType];
}
-(void)setIconImage:(NSString *)imageType{

}
-(IBAction)contentMessageListener:(id)sender{
  //弹出详细信息界面 并加载数据
  self.messageViewController = [[GDDDescriptionMessageViewController_ipad alloc]initWithNibName:@"GDDDescriptionMessageViewController_ipad" bundle:nil];
  [self.messageViewController presentViewControllerCompletion:^(BOOL finished) {
  }];
}

#pragma mark KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath
										 ofObject:(id)object
											 change:(NSDictionary *)change
											context:(void *)context {
  
  if ((__bridge id)context == self) {// Our notification, not our superclass’s
    if ([keyPath isEqualToString:isControllerDealloc]) {
      // 外部控制器, 已经被释放了, 在这里释放cell占用的资源
      [self.contentListImageView cancelOperation];
      [object removeObserver:self forKeyPath:isControllerDealloc];
      [object resetIsControllerDeallocTag];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

@end
