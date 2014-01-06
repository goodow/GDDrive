//
//  GDDEquipmentView.m
//  GDDrive
//
//  Created by 大黄 on 13-12-2.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDEquipmentView.h"
#import "GDDPlistHelper.h"
@interface GDDEquipmentView()

@property (nonatomic, weak) IBOutlet UIView *heaPortraitView;
@property (nonatomic, weak) IBOutlet UILabel *loginNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, strong) SetingBlock settingBlock;

-(IBAction)setingListener:(id)sender;
@end
@implementation GDDEquipmentView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code

  }
  return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if (self = [super initWithCoder:aDecoder]) {

  }
  return self;
}

-(void)setViewStyle{
  [self.heaPortraitView.layer setBorderWidth:1.0f];
  [self.heaPortraitView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
  [self.heaPortraitView.layer setShadowOffset:CGSizeMake(-1, 0)];
  [self.heaPortraitView.layer setShadowOpacity:0.4f];
  [self.heaPortraitView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];
}
-(void)setClickBlock:(SetingBlock)block{
  self.settingBlock = block;
}
-(IBAction)setingListener:(id)sender{
  if (self.settingBlock) {
    self.settingBlock();
  }
}
-(void)bindData{
  self.loginNameLabel.text = [[GDDPlistHelper sharedInstance]objectFromPlistKey:@"name"];
  self.nickNameLabel.text = [[GDDPlistHelper sharedInstance]objectFromPlistKey:@"display_name"];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
