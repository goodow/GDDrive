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
#import "GDDGenreImageDictionary.h"
#import "UIImageView+MKNetworkKitAdditions.h"

@interface GDDContentListCell_ipad()

@property (nonatomic, weak) IBOutlet UIImageView *contentListImageView;
@property (nonatomic, weak) IBOutlet UILabel *contentListLabel;
@property (nonatomic, strong, readwrite) GDDDescriptionMessageViewController_ipad *messageViewController;
@property (nonatomic, strong, readwrite) GDRCollaborativeMap *map;

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
  [self.contentListImageView cancelOperation];
  if ([imageType isEqualToString:@"image/jpeg"] || [imageType isEqualToString:@"image/png"]) {
    [self.contentListImageView setImageFromURL:[NSURL URLWithString:[self.map get:@"thumbnail"]]
                              placeHolderImage:[UIImage imageNamed:[[GDDGenreImageDictionary sharedInstance]imageNameByKey:imageType]]];
  }else{
    [self.contentListImageView setImage:[UIImage imageNamed:[[GDDGenreImageDictionary sharedInstance]imageNameByKey:imageType]]];
  }
}
-(void)bindWithDataBean:(GDRCollaborativeMap *)aMap{
  self.map = aMap;
  [self setLabel:[aMap get:@"label"]];
  if ([aMap get:@"type"]) [self setContentType:[aMap get:@"type"]];
  if ([aMap get:@"isclass"]) [[aMap get:@"isclass"]booleanValue] ?[self setContentType:@"noClass"]:[self setContentType:@"isClass"];
}
-(IBAction)contentMessageListener:(id)sender{
  //弹出详细信息界面 并加载数据
  self.messageViewController = [[GDDDescriptionMessageViewController_ipad alloc]initWithNibName:@"GDDDescriptionMessageViewController_ipad" bundle:nil];
  [self.messageViewController presentViewControllerCompletion:^(BOOL finished) {
  }];
  [self.messageViewController updateData:self.map];
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
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

@end
