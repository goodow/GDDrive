//
//  GDDContentListCell_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-19.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDContentListCell_ipad.h"
#import "GDDDescriptionMessageViewController_ipad.h"
@interface GDDContentListCell_ipad()

@property (nonatomic, weak) IBOutlet UIImageView *contentListImageView;
@property (nonatomic, weak) IBOutlet UILabel *contentListLabel;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) GDDDescriptionMessageViewController_ipad *messageViewController;

-(IBAction)contentMessageListener:(id)sender;
@end
@implementation GDDContentListCell_ipad

-(void)setLabel:(NSString *)text{
  [self.contentListLabel setText:text];
}
-(void)setContentType:(NSString *)aContentType{
  if ([aContentType isEqualToString:@"isClass"]) {
    [self setIconImage:@"class_icon.png"];
  }else if ([aContentType isEqualToString:@"noClass"]){
    [self setIconImage:@"offline_files_icon.png"];
  }else if ([aContentType isEqualToString:@"image/jpeg"]){
    [self setIconImage:@"favicons_icon.png"];
  }else if ([aContentType isEqualToString:@"image/png"]){
    [self setIconImage:@"favicons_icon.png"];
  }else if ([aContentType isEqualToString:@"video/mp4"]){
    [self setIconImage:@"favicons_icon.png"];
  }else if ([aContentType isEqualToString:@"video/mp3"]){
    [self setIconImage:@"favicons_icon.png"];
  }else if ([aContentType isEqualToString:@"application/pdf"]){
    [self setIconImage:@"favicons_icon.png"];
  }
  
}
-(void)setIconImage:(NSString *)image{
  [self.contentListImageView setImage:[UIImage imageNamed:image] ];
}
-(IBAction)contentMessageListener:(id)sender{
  self.messageViewController = [[GDDDescriptionMessageViewController_ipad alloc]initWithNibName:@"GDDDescriptionMessageViewController_ipad" bundle:nil];
  [self.messageViewController presentViewController];
}
@end
