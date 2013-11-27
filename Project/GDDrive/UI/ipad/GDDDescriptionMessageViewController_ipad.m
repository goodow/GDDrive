//
//  GDDDescriptionMessageViewController.m
//  GDDrive
//
//  Created by 大黄 on 13-11-12.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "GDDDescriptionMessageViewController_ipad.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "GDDGenreDictionary.h"
#import "Boolean.h"
#import "GDDOffineFilesHelper.h"

@interface GDDDescriptionMessageViewController_ipad ()
@property (nonatomic, weak) IBOutlet UIView *mainMessageView;
@property (nonatomic, weak) IBOutlet UIView *messageView;
@property (nonatomic, weak) IBOutlet UIView *offlineView;
@property (nonatomic, weak) IBOutlet UISwitch *offlineSwitch;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *fileOrfolderNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fileOrfolderTypeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *fileOrfolderImageView;

@property (nonatomic, strong) GDRCollaborativeMap *map;

@property (nonatomic, strong) GDRDocument *doc;
@property (nonatomic, strong) GDRModel *mod;
@property (nonatomic, strong) GDRCollaborativeMap *root;
@property (nonatomic, strong) GDRCollaborativeList *offlineList;
@property (nonatomic, strong) GDRCollaborativeMap *offlineMap;


-(IBAction)dismissViewListener:(id)sender;
-(IBAction)switchListener:(id)sender;
-(IBAction)openMultimediaListener:(id)sender;
@end

@implementation GDDDescriptionMessageViewController_ipad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.mainMessageView.layer setBorderWidth:1.0f];
  [self.mainMessageView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
  [self.mainMessageView.layer setShadowOffset:CGSizeMake(-1, 0)];
  [self.mainMessageView.layer setShadowOpacity:0.4f];
  [self.mainMessageView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];
  
  [self.messageView.layer setBorderWidth:1.0f];
  [self.messageView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
  [self.messageView.layer setShadowOffset:CGSizeMake(-1, 1)];
  [self.messageView.layer setShadowOpacity:0.2f];
  [self.messageView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];
  
  [self.offlineView.layer setBorderWidth:1.0f];
  [self.offlineView.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
  [self.offlineView.layer setShadowOffset:CGSizeMake(-1, 1)];
  [self.offlineView.layer setShadowOpacity:0.2f];
  [self.offlineView.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];//  [self presentViewController];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (void)updateData:(GDRCollaborativeMap *)map{
  self.map = map;
  //这里要更改为抽象 加载map 并根据map指示的类型去让 界面展示图片或者是 文件类型图 文件名 类型等等数据
  //这里 暂时认为只是加载图片而已
  //加载图片的相关解析数据
  //-------unfinished--------加载前应该判断是否要判断是否已经在离线管理并已经下载，如果下载完成则应直接读取本地数据，这里只是针对于图片，其他格式不需要
  
  //针对于文件夹和课程文件
  //文件夹 课程夹 信息展示
  [self.fileOrfolderNameLabel setText:[map get:@"label"]];
  //默认离线不可用 并且默认全部为普通文件夹
  [self.offlineSwitch setEnabled:NO];
  [self.thumbnailImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]largeImageNameByKey:@"noClass"]]];
  [self.fileOrfolderImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]tinyImageNameByKey:@"noClass"]]];
  [self.fileOrfolderTypeLabel setText:@"文件夹"];
  
  if ([map get:@"isclass"]) {
    [self.offlineSwitch setEnabled:NO];
    if ([[map get:@"isclass"]booleanValue]) {
      //如果是课程文件夹
      [self.thumbnailImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]largeImageNameByKey:@"isClass"]]];
      [self.fileOrfolderImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]tinyImageNameByKey:@"isClass"]]];
      [self.fileOrfolderTypeLabel setText:@"课程文件夹"];
    }else{
      //普通文件夹
      [self.thumbnailImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]largeImageNameByKey:@"noClass"]]];
      [self.fileOrfolderImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]tinyImageNameByKey:@"noClass"]]];
      [self.fileOrfolderTypeLabel setText:@"文件夹"];
    }
  }
  //资源文件 包括 JPG PNG SWF PDF MP3 MP4 信息展示
  if ([map get:@"type"]) {
    [self.offlineSwitch setEnabled:YES];
    [self.fileOrfolderImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]tinyImageNameByKey:[map get:@"type"]]]];
    [self.fileOrfolderTypeLabel setText:[map get:@"type"]];
    //加载是否已经添加离线
    __weak GDDDescriptionMessageViewController_ipad *weakSelf = self;
    [GDRRealtime load:[NSString stringWithFormat:@"%@/%@/%@",GDDConfigPlist(@"documentId"),GDDConfigPlist(@"userId"),GDDConfigPlist(@"offlinedoc")]
             onLoaded:^(GDRDocument *document) {
               weakSelf.doc = document;
               weakSelf.mod = [weakSelf.doc getModel];
               weakSelf.root = [weakSelf.mod getRoot];
               weakSelf.offlineList = [weakSelf.root get:@"offline"];
//               id block = ^(GDRBaseModelEvent *event) {
//                 NSLog(@"weakSelf.filesList listener");
//               };
//               [weakSelf.offlineList addValuesAddedListener:block];
//               [weakSelf.offlineList addValuesRemovedListener:block];
//               [weakSelf.offlineList addValuesSetListener:block];
               //判断资源是否已经加入了离线？
               [weakSelf.offlineList indexOf:[map get:@"id"] opt_comparator:^NSComparisonResult(id obj1, id obj2) {
                 [weakSelf.offlineSwitch setOn:NO];
                 if (![obj2 isKindOfClass:[GDRCollaborativeMap class]]) {
                   return -1;
                 }
                 if ([[obj1 description] isEqualToString:[[(GDRCollaborativeMap *)obj2 get:@"id"]description]]) {
                   [weakSelf.offlineSwitch setOn:YES];
                   weakSelf.offlineMap = obj2;
                   return NSOrderedSame;
                 }
                 return -1;
               }];
               
             } opt_initializer:^(GDRModel *model) {
               //离线模型初始化
               GDRCollaborativeList *list = [self.mod createList:[NSArray array]];
               [self.root set:@"offline" value:list];
             } opt_error:^(GDRError *error) {
               
             }];
    
    if ([[map get:@"type"]isEqualToString:@"image/jpeg"] || [[map get:@"type"]isEqualToString:@"image/png"]) {
      //以下是图片
      //判断该资源是否已经下载
      GDDOffineFilesHelper *offlineHelp = [[GDDOffineFilesHelper alloc]init];
      if ([offlineHelp isAlreadyPresentInTheLocalFileByData:map]) {
        NSData *data = [offlineHelp readFileByData:map];
        [self.thumbnailImageView setImage:[UIImage imageWithData:data]];
      }else{
        [self.thumbnailImageView setImageFromURL:[NSURL URLWithString:GDDMultimediaHeadURL([map get:@"id"])]
                                placeHolderImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]largeImageNameByKey:[map get:@"type"]]]];
      }
    }else{
      //其他资源加载
      [self.thumbnailImageView setImage:[UIImage imageNamed:[[GDDGenreDictionary sharedInstance]largeImageNameByKey:[map get:@"type"]]]];
    }
  }
}

- (void)presentViewControllerCompletion:(CompletionBlock)completion{
  [GDDRiveDelegate.window addSubview:self.view];
  CGRect rect = [[UIScreen mainScreen] bounds];
  self.view.center = CGPointMake(rect.size.width, rect.size.height/2);
  self.view.alpha = 0.0f;
  [UIView animateWithDuration:0.3f animations:^{
    self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    self.view.alpha = 1.0f;
  } completion:^(BOOL finished) {
    completion(finished);
  }];
}
-(void)dismissViewControllerCompletion:(CompletionBlock)completion{
  //删除前要cancal所有网络资源
  [self.thumbnailImageView cancelOperation];
  CGRect rect = [[UIScreen mainScreen] bounds];
  self.view.center = CGPointMake(rect.size.width/2, rect.size.height/2);
  self.view.alpha = 1.0f;
  [UIView animateWithDuration:0.3f animations:^{
    self.view.center = CGPointMake(rect.size.width, rect.size.height/2);
    self.view.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [self.view removeFromSuperview];
    if (completion) completion(finished);
  }];
}

#pragma mark - IBAction
-(IBAction)dismissViewListener:(id)sender{
  [self dismissViewControllerCompletion:nil];
}
-(IBAction)openMultimediaListener:(id)sender{
  NSLog(@"openMultimediaListener");
}
-(IBAction)switchListener:(id)sender {
  UISwitch *switchButton = (UISwitch*)sender;
  BOOL isButtonOn = [switchButton isOn];
  if (isButtonOn) {
    //加入离线
    self.offlineMap = [self.mod createMap:@{@"url": GDDMultimediaHeadURL([self.map get:@"id"]),
                                            @"progress": @"0",
                                            @"status": @"未下载",
                                            @"label": [self.map get:@"label"],
                                            @"blobKey": [self.map get:@"blobKey"],
                                            @"id": [self.map get:@"id"],
                                            @"type": [self.map get:@"type"]}];
    if ([[self.map get:@"type"]isEqualToString:@"image/jpeg"] || [[self.map get:@"type"]isEqualToString:@"image/png"]) {
      //添加图片离线下载 比普通资源多缩略图
      [self.offlineMap set:@"thumbnail" value:[self.map get:@"thumbnail"]];
    }
    [self.offlineList push:self.offlineMap];
  }else {
    //关闭离线
    if (!self.offlineMap) {
      RNAssert(NO, @"详细信息中 离线文件信息 offlineMap 为空了");
    }
    GDDOffineFilesHelper *offlineFilesHelper = [[GDDOffineFilesHelper alloc]init];
    [offlineFilesHelper deleteLocalHostFileByData:self.offlineMap];
    [self.offlineList removeValue:self.offlineMap];
  }
  
}
@end
