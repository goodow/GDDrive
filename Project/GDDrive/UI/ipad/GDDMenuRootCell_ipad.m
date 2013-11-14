//
//  GDDMenuRootCell.m
//  GDDrive
//
//  Created by 大黄 on 13-11-14.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDMenuRootCell_ipad.h"

@interface GDDMenuRootCell_ipad ()
@property (nonatomic, weak) IBOutlet UIImageView *menuRootImageView;
@property (nonatomic, weak) IBOutlet UILabel *menuRootLabel;
@end

@implementation GDDMenuRootCell_ipad

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}
- (BOOL)isReadys {
  BOOL isProperty = NO;
  for (NSString *aProperty in self.propertys) {
   isProperty = [aProperty length] > 0;
  }
  return (self.object && isProperty);
}

- (void)updates {
  self.menuRootLabel.text = self.isReadys ? [[self.object valueForKeyPath:[self.propertys objectAtIndex:0]] description] : @"";
  self.menuRootImageView.image = self.isReadys ? [self.object valueForKeyPath:[self.propertys objectAtIndex:1]] : [UIImage imageNamed:@""];
}

- (void)addObservations{
  if (self.isReadys) {
    for (NSString *aProperty in self.propertys) {
      [self addObserver:self forKeyPath:aProperty options:0 context:(__bridge void*)self];
    }
  }
}
- (void)removeObservations {
  if (self.isReadys) {
    for (NSString *aProperty in self.propertys) {
      [self.object removeObserver:self forKeyPath:aProperty];
    }
  }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  if ((__bridge id)context == self) {
    [self updates];
  }else {
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
  }
  
}
- (void)dealloc {
  if (_object && [_propertys count] > 0) {
    for (NSString *aProperty in self.propertys) {
        if (_object && [aProperty length] > 0) {
          [_object removeObserver:self forKeyPath:aProperty];
        }
    }
  }
}
- (void)setObject:(id)anObject {
  [self removeObservations];
  _object = anObject;
  [self addObservations];
  [self updates];
}

-(void)setPropertys:(NSArray *)aPropertys {
  [self removeObservations];
  _propertys = aPropertys;
  [self addObservations];
  [self updates];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
