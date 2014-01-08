//
//  GDDEquipmentView.m
//  GDDrive
//
//  Created by 大黄 on 13-12-2.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDEquipmentView.h"
#import "GDDPlistHelper.h"
#import "GDDEquipmentModel.h"
@interface GDDEquipmentView()

@property (nonatomic, weak) IBOutlet UILabel *equipmentID;
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
-(void)setClickBlock:(SetingBlock)block{
  self.settingBlock = block;
}
-(IBAction)setingListener:(id)sender{
  if (self.settingBlock) {
    self.settingBlock();
  }
}
-(void)bindData{
  self.equipmentID.text = [GDDEquipmentModel sharedInstance].equipmentID;
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
