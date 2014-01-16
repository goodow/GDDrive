//
//  GDDHeXieViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-1-2.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDHeXieViewController.h"
#import "GDDBusProvider.h"
#import "GDDFolderCell.h"
#import "GDDAddr.h"

@interface GDDHeXieViewController ()
@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, weak) IBOutlet UIPickerView *searchPicker;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSDictionary *messageDic;

@property (nonatomic, strong) NSMutableArray *queryConditionList;
@property (nonatomic, strong) NSMutableArray *pathList;

@property (nonatomic, strong) id<GDCHandlerRegistration> localOpenHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> equipmendIDHandlerRegistration;
@end



@implementation GDDHeXieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.title = @"课程";
  
  [self.collectionView registerClass:[GDDFolderCell class] forCellWithReuseIdentifier:@"GDDFolderCell"];
  
  self.bus = [GDDBusProvider BUS];
  self.pathList = [NSMutableArray array];
  self.queryConditionList = [NSMutableArray array];
  
}
-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  __weak GDDHeXieViewController *weakSelf = self;
  [self handlerEventBusOpened];
  self.localOpenHandlerRegistration = [self.bus registerHandler:[GDCBus LOCAL_ON_OPEN] handler:^(id<GDCMessage> message) {
    //网络恢复和良好 解除模态
    NSLog(@"网络恢复和良好 解除模态");
  }];
  self.equipmendIDHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_DEVICE:GDDAddrReceive] handler:^(NSDictionary *message){
    [weakSelf handlerEventBusOpened];
  }];

}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
  [self.localOpenHandlerRegistration unregisterHandler];
  [self.equipmendIDHandlerRegistration unregisterHandler];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)handlerEventBusOpened{
  
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:@{@"action":@"post",@"query":@{@"type":@"入学准备"}} replyHandler:nil];
  
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:@{@"action":@"get",@"query":@{@"type":@"和谐",@"grade":@"小",@"term":@"上",@"topic":@"语言"}} replyHandler:^(id<GDCMessage> message) {
    NSLog(@"%@",message);
    self.messageDic = [message body];
    [self.collectionView reloadData];
  }];
  [self recursiveQuery:self.pathList];
}


//查询从跟目录到最后一级查询条件的，所有分级查询条件
-(void)recursiveQuery:(NSMutableArray *)aPathList{
  NSString *path = @"goodow/drive";
  for (NSString *str in aPathList) {
    path = [NSString stringWithFormat:@"%@/%@",path,str];
  }
  __weak GDDHeXieViewController *weakSelf = self;
  [self.bus send:[GDDAddr FILE:GDDAddrSendRemote] message:@{@"path":path} replyHandler:^(id<GDCMessage> message) {
    NSDictionary *dic = [message body];
    NSArray *arr = dic[@"folders"];
    
    if ([arr count]>0) {
      NSString *str = arr[0];
      NSString * regex = @"(^[0-9]{0,4}$)";
      NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
      do {
        if ([str length] < 4 ) {
          [weakSelf.pathList addObject:str];
          [weakSelf.queryConditionList addObject:arr];
          break;
        }
        BOOL isMatch = [pred evaluateWithObject:[str substringToIndex:4]];
        if (isMatch) {
          [weakSelf.searchPicker reloadAllComponents];
          [weakSelf concatSendMessage];
          return;
        }else{
          [weakSelf.pathList addObject:str];
          [weakSelf.queryConditionList addObject:arr];
          break;
        }
      } while (NO);
      [weakSelf recursiveQuery:weakSelf.pathList];
    }else{
      [weakSelf.searchPicker reloadAllComponents];
      [weakSelf concatSendMessage];
    }
  }];
}
- (void)concatSendMessage{
  NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
  switch ([self.pathList count]) {
    case 4:
      queryDic[@"topic"] = self.pathList[3];
    case 3:
      queryDic[@"term"] = self.pathList[2];
    case 2:
      queryDic[@"grade"] = self.pathList[1];
    case 1:
      queryDic[@"type"] = self.pathList[0];
      
    default:
      break;
  }
  
  //推送跳转界面
  NSMutableDictionary *pushInterfaceMessageDic = [NSMutableDictionary dictionary];
  pushInterfaceMessageDic[@"action"] = @"post";
  pushInterfaceMessageDic[@"query"] = queryDic;
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:pushInterfaceMessageDic replyHandler:nil];

  //获取跳转界面数据
  NSMutableDictionary *accessToDataMessageDic = [NSMutableDictionary dictionary];
  accessToDataMessageDic[@"action"] = @"get";
  accessToDataMessageDic[@"query"] = queryDic;
  __weak GDDHeXieViewController *weakSelf = self;
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:accessToDataMessageDic replyHandler:^(id<GDCMessage> message) {
    weakSelf.messageDic = [message body];
    [weakSelf.collectionView reloadData];
  }];
}

#pragma mark -picker view delegate datasouce
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  
  NSString *selectTag = self.queryConditionList[component][row];
  self.pathList[component] = selectTag;

  for (int i = [self.queryConditionList count] - 1; i > component ; i--) {
    [self.queryConditionList removeObjectAtIndex:i];
    [self.pathList removeObjectAtIndex:i];
  }
  [self.searchPicker reloadAllComponents];
  [self recursiveQuery:self.pathList];
  
  
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 4;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  if ([self.queryConditionList count] > component) {
    return [self.queryConditionList[component] count];
  }
  return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  if ([self.queryConditionList count] > component) {
    return self.queryConditionList[component][row];
  }
  return @"";
}

#pragma mark - collection view delegate and datasouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  // 每个Section的item个数
  if (self.messageDic[@"activities"] == nil) {
    return 0;
  }
  return [self.messageDic[@"activities"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  GDDFolderCell *cell = (GDDFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GDDFolderCell" forIndexPath:indexPath];
  cell.titleLabel.text = @"";
  if ([self.messageDic[@"activities"] count] > 0) {
    cell.titleLabel.text = self.messageDic[@"activities"][indexPath.row][@"title"];
  }
  return cell;
}

@end
