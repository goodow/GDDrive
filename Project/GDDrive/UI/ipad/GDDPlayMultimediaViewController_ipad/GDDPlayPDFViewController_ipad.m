//
//  GDDPlayPDFViewController_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-27.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDPlayPDFViewController_ipad.h"
#import "GDDOffineFilesHelper.h"

@interface GDDPlayPDFViewController_ipad () <ReaderViewControllerDelegate>
@property (nonatomic, strong) DismissReaderViewControllerBlock dismissReaderViewControllerBlock;


@end

@implementation GDDPlayPDFViewController_ipad

- (id)initWithDataBean:(GDRCollaborativeMap *)map
    dismissReaderBlock:(DismissReaderViewControllerBlock)block
          successBlock:(LoadReaderViewControllerSuccessBlock)successBlock
            failureBlock:(LoadReaderViewControllerErrorBlock)errorBlock{
  
  NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
  GDDOffineFilesHelper *offlineHelp = [[GDDOffineFilesHelper alloc]init];
  NSString *filePath = [offlineHelp filePathOfHaveDownloadedByData:map];
  if (!filePath) {
    if (self = [super init]) {
      errorBlock(GDD_PLAY_PDF_NO_LOCAL_FILE,@"本地文件不存在 \n需要开启离线并下载");
    }
    return self;
  }
  ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
  if (document != nil) // Must have a valid ReaderDocument object in order to proceed
  {
    if (self = [super initWithReaderDocument:document]) {
      self.delegate = self;
      self.dismissReaderViewControllerBlock = block;
      successBlock(self);
      return self;
    }
  }else{
    if (self = [super init]) {
      DLog(@"GDDPlayPDFViewController_ipad init 初始化数据发生错误，没有正常初始化成功")
          errorBlock(GDD_PLAY_PDF_INIT_FAILURE,@"无法初始化PDF");
    }
    return self;
  }
  return nil;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
   [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - ReaderViewController delegate
-(void)dismissReaderViewController:(ReaderViewController *)viewController{
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    GDDRiveDelegate.window.clipsToBounds =YES;
    GDDRiveDelegate.window.frame =  CGRectMake(0,20,GDDRiveDelegate.window.frame.size.width,GDDRiveDelegate.window.frame.size.height-20);
  }
  self.dismissReaderViewControllerBlock(viewController);
}
@end
