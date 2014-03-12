//
//  GDDActivityViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-2-28.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDActivityViewController.h"
#import "GDDFolderCell.h"
#import "GDDBusProvider.h"
#import "GDDAddr.h"

@interface GDDActivityViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) id<GDCHandlerRegistration> activityHandlerRegistration;
@property (nonatomic, strong) NSMutableDictionary *attachments;

@end

@implementation GDDActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    
  }
  return self;
}

- (void)viewDidLoad{
  [super viewDidLoad];
  self.attachments = [NSMutableDictionary dictionary];
  [self.collectionView registerClass:[GDDFolderCell class] forCellWithReuseIdentifier:@"GDDFolderCell"];
}
-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self regisetActivityChangeHandler];
  }

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self unregisetActivityChangeHandler];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - 注册活动变化监听
-(void)regisetActivityChangeHandler{
  // 接收控制信息回调 根据数据跳转
  self.activityHandlerRegistration = [[GDDBusProvider sharedInstance] registerHandler:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_ACTIVITY_DATA addressStyle:GDDAddrReceive] handler:^(id <GDCMessage> message){
    NSLog(@"%@",[message body]);
    //控制安卓设备跳转到活动界面
    //注意 ： 这里剔除4位前缀 在之后要改正！！！！！！！！！！！！！！
    [[GDDBusProvider sharedInstance] send:[GDDAddr addressProtocol:ADDR_ACTIVITY addressStyle:GDDAddrSendRemote] message:@{@"action":@"post", @"tags":[message body][@"tags"], @"title":[[message body][@"title"]substringFromIndex:4] } replyHandler:nil];
    _titleLabel.text = [message body][@"title"];
    
    [[GDDBusProvider sharedInstance] send:[GDDAddr addressProtocol:ADDR_ATTACHMEND_SEARCH addressStyle:GDDAddrSendRemote] message:@{@"tags":[message body][@"tags"]} replyHandler:^(id <GDCMessage> message){
      NSLog(@"%@",[message body]);
      _attachments = [message body];
      [_collectionView reloadData];
    }];
  }];

}
-(void)unregisetActivityChangeHandler{
  [self.activityHandlerRegistration unregisterHandler];
}

-(IBAction)backAction:(id)sender{

}

#pragma mark - collection view delegate and datasouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  NSArray *attachments =_attachments[@"attachments"];
  return attachments.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  GDDFolderCell *cell = (GDDFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GDDFolderCell" forIndexPath:indexPath];
  cell.titleLabel.text = @"";
  NSArray *attachments =_attachments[@"attachments"];
  if (attachments.count > 0) {
    cell.titleLabel.text = attachments[indexPath.row][@"name"];
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  NSLog(@"didSelectItemAtIndexPath");

//  {"size":46.0,"attachments":
//    [{
//      "id":"15",
//      "name":"甜甜的手掌",
//      "contentType":"application/pdf",
//      "contentLength":0.0,
//      "url":"goodow/drive/和谐/大/上/科学/0017甜甜的手掌/活动设计-甜甜的手掌(早期阅读).pdf",
//      "thumbnail":null}]
//  }
//  [self.bus send:[GDDAddr GDD_LOCAL_ADDR_TOPIC_ACTIVITY:GDDAddrSendLocal] message:@{@"aaa":@"bbb"} replyHandler:nil];
}
@end
