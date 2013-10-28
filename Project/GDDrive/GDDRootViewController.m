//
//  GDDRootViewController.m
//  TestOne
//
//  Created by 大黄 on 13-10-23.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDRootViewController.h"
#import "GDDClassViewController_iPad.h"
#import "GDDFaviconsViewController_iPad.h"
#import "GDDOfflineFilesViewController_iPad.h"
#import "GDR.h"

@interface GDDRootViewController ()
@property (nonatomic, weak) IBOutlet UIView *contextView;
@property (nonatomic, strong) UIViewController *currentViewController;
-(IBAction)classOnClickListener:(id)sender;
-(IBAction)faviconsOnClickListener:(id)sender;
-(IBAction)offlineFilesOnClickListener:(id)sender;
@end

@implementation GDDRootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
  [GDRRealtime setServerAddress:@"http://drive.retechcorp.com:8080"];
  [GDRRealtime authorize:[dictionary objectForKey:@"userId"] token:[dictionary objectForKey:@"token"]];

  GDDClassViewController_iPad *classViewController=[[GDDClassViewController_iPad alloc] initWithNibName:@"GDDClassViewController_iPad" bundle:nil];
  UINavigationController *classNavigationController = [[UINavigationController alloc]initWithRootViewController:classViewController];
  [self addChildViewController:classNavigationController];
  
  GDDFaviconsViewController_iPad *faviconsViewController=[[GDDFaviconsViewController_iPad alloc] initWithNibName:@"GDDFaviconsViewController_iPad" bundle:nil];
  UINavigationController *aviconsNavigationController = [[UINavigationController alloc]initWithRootViewController:faviconsViewController];
  [self addChildViewController:aviconsNavigationController];
  
  GDDOfflineFilesViewController_iPad *offlineFilesViewController = [[GDDOfflineFilesViewController_iPad alloc] initWithNibName:@"GDDOfflineFilesViewController_iPad" bundle:nil];
  UINavigationController *offlineNavigationController = [[UINavigationController alloc]initWithRootViewController:offlineFilesViewController];
  [self addChildViewController:offlineNavigationController];
  
  [self.contextView addSubview:classNavigationController.view];
  self.currentViewController = classNavigationController;
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
-(void)transitionFromChildViewControllerToViewControllerByIndex:(NSInteger)index{
  if (self.currentViewController == [self.childViewControllers objectAtIndex:index]) return;
  __weak GDDRootViewController *weakSelf = self;
  [self transitionFromViewController:self.currentViewController
                    toViewController:[self.childViewControllers objectAtIndex:index]
                            duration:1
                             options:UIViewAnimationOptionTransitionNone
                          animations:nil
                          completion:^(BOOL finished) {
                            if (finished) {
                              weakSelf.currentViewController=[weakSelf.childViewControllers objectAtIndex:index];
                            }
                          }];
}

#pragma mark IBAction
-(IBAction)classOnClickListener:(id)sender{
  [self transitionFromChildViewControllerToViewControllerByIndex:0];
}
-(IBAction)faviconsOnClickListener:(id)sender{
  [self transitionFromChildViewControllerToViewControllerByIndex:1];
}
-(IBAction)offlineFilesOnClickListener:(id)sender{
  [self transitionFromChildViewControllerToViewControllerByIndex:2];
}

@end
