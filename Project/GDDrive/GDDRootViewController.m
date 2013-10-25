//
//  GDDRootViewController.m
//  TestOne
//
//  Created by 大黄 on 13-10-23.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDRootViewController.h"
#import "GDDClassViewController_iPad.h"

@interface GDDRootViewController ()
@property (nonatomic, weak) IBOutlet UIView *contextView;
-(IBAction)classOnClickListener:(id)sender;
-(IBAction)faviconsOnClickListener:(id)sender;
-(IBAction)offlineFilesOnClickListener:(id)sender;
@end

@implementation GDDRootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  GDDClassViewController_iPad *viewController_iPad=[[GDDClassViewController_iPad alloc] initWithNibName:@"GDDClassViewController_iPad" bundle:nil];
  [self addChildViewController:viewController_iPad];
  [self.contextView addSubview:viewController_iPad.view];
  
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark IBAction
-(IBAction)classOnClickListener:(id)sender{
  
}
-(IBAction)faviconsOnClickListener:(id)sender{
  
}
-(IBAction)offlineFilesOnClickListener:(id)sender{
  
}

@end
