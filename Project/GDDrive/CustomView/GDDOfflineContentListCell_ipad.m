//
//  GDDOfflineContentListCell_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-22.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDOfflineContentListCell_ipad.h"
#import "GDDOffineFilesHelper.h"
#import "GDDDownloadWorkContext.h"

@interface GDDOfflineContentListCell_ipad()

@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) GDDDownloadWorkContext *workContext;

//-(IBAction)onCircularProgressViewListener:(id)sender;
-(IBAction)onClickDownloadWorkButtonListener:(id)sender;
@end
@implementation GDDOfflineContentListCell_ipad

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
    _workContext = [[GDDDownloadWorkContext alloc]init];
  }
  return self;
}
-(void)bindWithDataBean:(GDRCollaborativeMap *)aMap{
  [super bindWithDataBean:aMap];
  __weak GDDOfflineContentListCell_ipad *weakSelf = self;
  [self.workContext bindWithDataBean:aMap
                   TitleChangedBlock:^(NSString *title) {
                     [weakSelf.downloadButton setTitle:title forState:UIControlStateNormal];
    }
                  EnableChangedBlock:^(BOOL enable) {
                    [weakSelf.downloadButton setEnabled:enable];
    }
                ProgressChangedBlock:^(double progress) {
                  [weakSelf.progressView setProgress:progress/100.0f animated:YES];
  }];
}
-(IBAction)contentMessageListener:(id)sender{
  [self.workContext interruptHandling];
  [super contentMessageListener:sender];
}

-(void)onClickDownloadWorkButtonListener:(id)sender{
  [self.workContext triggerStateAction];
  
  
}

@end
