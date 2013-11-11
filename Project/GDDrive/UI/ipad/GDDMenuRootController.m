//
//  GDDMenuRootController.m
//  GDDrive
//
//  Created by 大黄 on 13-11-11.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDMenuRootController.h"
#import "GDDClassViewController_iPad.h"
#import "GDDFaviconsViewController_iPad.h"
#import "GDDOfflineFilesViewController_iPad.h"
#import "GDR.h"
#import "GDDRealtimeDataToViewController.h"
#import "PSStackedView.h"
#import "GDDAppDelegate.h"

@interface GDDMenuRootController ()
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) id <GDRealtimeProtocol> realtimeProtocol;

@property (nonatomic, strong) GDRCollaborativeMap *remotecontrolRoot;
@property (nonatomic, strong) GDRCollaborativeMap *cachePath;

@property (nonatomic, strong) UINavigationController *classNavigationController;
@property (nonatomic, strong) UINavigationController *faviconsNavigationController;
@property (nonatomic, strong) UINavigationController *offlineNavigationController;
@property (nonatomic, strong) UINavigationController *descriptionMessageNavigationController;
@property (nonatomic, strong) NSMutableArray *childViewController;

-(IBAction)classOnClickListener:(id)sender;
-(IBAction)faviconsOnClickListener:(id)sender;
-(IBAction)offlineFilesOnClickListener:(id)sender;

@end

@implementation GDDMenuRootController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.childViewController = [NSMutableArray array];
  NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
  //  [GDRRealtime setServerAddress:@"http://drive.retechcorp.com:8080"];
  [GDRRealtime setServerAddress:@"http://61.177.139.216:8084"];
  [GDRRealtime authorize:[dictionary objectForKey:@"userId"] token:[dictionary objectForKey:@"token"]];
  
  GDDClassViewController_iPad *classViewController=[[GDDClassViewController_iPad alloc] initWithNibName:@"GDDClassViewController_iPad" bundle:nil];
  self.classNavigationController = [[UINavigationController alloc]initWithRootViewController:classViewController];
  [self.childViewController addObject:self.classNavigationController];
  
  GDDFaviconsViewController_iPad *faviconsViewController=[[GDDFaviconsViewController_iPad alloc] initWithNibName:@"GDDFaviconsViewController_iPad" bundle:nil];
  self.faviconsNavigationController = [[UINavigationController alloc]initWithRootViewController:faviconsViewController];
  [self.childViewController addObject:self.faviconsNavigationController];
  
  GDDOfflineFilesViewController_iPad *offlineFilesViewController = [[GDDOfflineFilesViewController_iPad alloc] initWithNibName:@"GDDOfflineFilesViewController_iPad" bundle:nil];
  self.offlineNavigationController = [[UINavigationController alloc]initWithRootViewController:offlineFilesViewController];
  [self.childViewController addObject:self.offlineNavigationController];
  
  __weak GDDMenuRootController *weakSelf = self;
  self.realtimeProtocol = [[GDDRealtimeDataToViewController alloc]
                           initWithTransitionFromChildViewControllerToViewControllerBlock:^(NSInteger i) {
                             [weakSelf transitionChildViewControllerByIndex:i];
                           } ObjectsAndKeys:
                           classViewController,[dictionary objectForKey:@"lesson"],
                           faviconsViewController,[dictionary objectForKey:@"favorites"],
                           offlineFilesViewController,[dictionary objectForKey:@"offlinedoc"],nil];
  
  //记录和监听文件目录
  [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",[dictionary objectForKey:@"documentId"],[dictionary objectForKey:@"userId"],[dictionary objectForKey:@"remotecontrol"]]
           onLoaded:^(GDRDocument *document) {
             GDRModel *mod = [document getModel];
             weakSelf.cachePath = [[mod getRoot] get:@"path"];
             weakSelf.remotecontrolRoot = [mod getRoot];
             [weakSelf.realtimeProtocol loadRealtimeData:mod];
             [weakSelf.remotecontrolRoot addValueChangedListener:^(GDRValueChangedEvent *event) {
               do {
                 if (![[event getProperty] isEqualToString:@"path"]) break;
                 if ([[weakSelf.cachePath description] isEqualToString:[[[mod getRoot] get:@"path"] description]]) break;
                 weakSelf.cachePath = [[mod getRoot] get:@"path"];
                 [weakSelf.realtimeProtocol loadRealtimeData:mod];
               } while (NO);
             }];
             
           }
    opt_initializer:^(GDRModel *model) {}
          opt_error:^(GDRError *error) {}];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
-(void)transitionChildViewControllerByIndex:(NSInteger)index{
  if (self.currentViewController == [self.childViewController objectAtIndex:index]) return;
  [GDDRiveDelegate.stackController popViewControllerAnimated:YES];
  [GDDRiveDelegate.stackController pushViewController:[self.childViewController objectAtIndex:index] fromViewController:nil animated:NO];
  self.currentViewController = [self.childViewController objectAtIndex:index];
}
-(void)transitionChildViewControllerAndIntoRootPathByKey:(NSString *)key{
  GDRCollaborativeMap *path = [self.remotecontrolRoot get:@"path"];
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
  NSString *newCurrentdocid = [NSString stringWithFormat:@"%@/%@/%@",[dictionary objectForKey:@"documentId"],[dictionary objectForKey:@"userId"],[dictionary objectForKey:key]];
  id <GDJsonString> jsonCurrentdocid = [GDJson createString:newCurrentdocid];
  id <GDJsonArray> jsonCurrentpath = [GDJson createArray];
  [jsonCurrentpath set:0 string:@"root"];
  [path set:@"currentdocid" value:jsonCurrentdocid];
  [path set:@"currentpath" value:jsonCurrentpath];
  [self.remotecontrolRoot set:@"path" value:path];
}
#pragma mark IBAction
-(IBAction)classOnClickListener:(id)sender{
  if (self.remotecontrolRoot) {
    [self transitionChildViewControllerAndIntoRootPathByKey:@"lesson"];
    [self transitionChildViewControllerByIndex:0];
  }
}
-(IBAction)faviconsOnClickListener:(id)sender{
  if (self.remotecontrolRoot) {
    [self transitionChildViewControllerAndIntoRootPathByKey:@"favorites"];
    [self transitionChildViewControllerByIndex:1];
  }
}
-(IBAction)offlineFilesOnClickListener:(id)sender{
  if (self.remotecontrolRoot) {
    [self transitionChildViewControllerAndIntoRootPathByKey:@"offlinedoc"];
    [self transitionChildViewControllerByIndex:2];
  }
}

@end