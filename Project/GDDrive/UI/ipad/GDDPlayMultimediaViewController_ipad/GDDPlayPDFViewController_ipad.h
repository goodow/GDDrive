//
//  GDDPlayPDFViewController_ipad.h
//  GDDrive
//
//  Created by 大黄 on 13-11-27.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "ReaderViewController.h"
typedef enum {
  GDD_PLAY_PDF_NO_LOCAL_FILE = 0,
  GDD_PLAY_PDF_INIT_FAILURE,
} GDDPlayPDFError;


typedef void (^DismissReaderViewControllerBlock)(ReaderViewController *viewController);
typedef void (^LoadReaderViewControllerSuccessBlock)(ReaderViewController *viewController);
typedef void (^LoadReaderViewControllerErrorBlock)(GDDPlayPDFError error, NSString *errorMessage);

@interface GDDPlayPDFViewController_ipad : ReaderViewController

//@property (nonatomic, strong) ReaderViewController *readerViewController;

@end
