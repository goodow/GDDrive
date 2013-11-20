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
@interface GDDContentListCell_ipad()

@property (nonatomic, weak) IBOutlet UIImageView *contentListImageView;
@property (nonatomic, weak) IBOutlet UILabel *contentListLabel;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) GDDDescriptionMessageViewController_ipad *messageViewController;
@property (nonatomic, strong) GDRCollaborativeMap *map;

-(IBAction)contentMessageListener:(id)sender;
@end
@implementation GDDContentListCell_ipad

-(void)setLabel:(NSString *)text{
  [self.contentListLabel setText:text];
}
-(void)setContentType:(NSString *)aContentType{
  [self setIconImage:[[GDDGenreImageDictionary sharedInstance]imageNameByKey:aContentType]];
}
-(void)setIconImage:(NSString *)image{
  [self.contentListImageView setImage:[UIImage imageNamed:image] ];
}
-(void)setCellData:(GDRCollaborativeMap *)aMap{
  self.map = aMap;
  [self setLabel:[aMap get:@"label"]];
  
  if ([aMap get:@"type"]) [self setContentType:[aMap get:@"type"]];
  if ([aMap get:@"isclass"]) [[aMap get:@"isclass"]booleanValue] ?[self setContentType:@"noClass"]:[self setContentType:@"isClass"];
}
-(IBAction)contentMessageListener:(id)sender{
  self.messageViewController = [[GDDDescriptionMessageViewController_ipad alloc]initWithNibName:@"GDDDescriptionMessageViewController_ipad" bundle:nil];
  [self.messageViewController presentViewControllerCompletion:^(BOOL finished) {
    NSLog(@"messageViewController presentViewController finished");
  }];
  [self.messageViewController updateData:self.map];
}
@end
