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
@property (nonatomic, strong) NSMutableDictionary *selectedDic;

@property (nonatomic, strong) id<GDCHandlerRegistration> equipmendIDHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichClassHandlerRegistration;
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
  self.equipmendIDHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_DEVICE:GDDAddrReceive] handler:^(NSDictionary *message){
    
  }];
  self.swichClassHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_CLASS:GDDAddrReceive] handler:^(id <GDCMessage> message){
    NSLog(@"swichClassHandlerRegistration");
    [weakSelf recursiveQuery:weakSelf.pathList];
    weakSelf.selectedDic = [message body];
  }];


}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.equipmendIDHandlerRegistration unregisterHandler];
  [self.swichClassHandlerRegistration unregisterHandler];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  NSDictionary *map = @{@"和谐": @"type",@"收藏": @"type",@"托班": @"type",@"示范课": @"type",@"入学准备": @"type",@"智能开发": @"type",@"电子书": @"type",
                        @"大": @"grade",@"中": @"grade",@"小": @"grade",@"学前": @"grade",
                        @"上":@"term",@"下":@"term"};
  
  for (NSString *str in self.pathList) {
    if ([map[str] isEqualToString:@"type"]) {
      queryDic[@"type"] = str;
    } else if ([map[str] isEqualToString:@"grade"]) {
      queryDic[@"grade"] = str;
    } else if ([map[str] isEqualToString:@"term"]) {
      queryDic[@"term"] = str;
    } else{
      queryDic[@"topic"] = str;
    }
  }
  
  //推送跳转界面
  NSMutableDictionary *pushInterfaceMessageDic = [NSMutableDictionary dictionary];
  pushInterfaceMessageDic[@"action"] = @"post";
  pushInterfaceMessageDic[@"queries"] = queryDic;
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:pushInterfaceMessageDic replyHandler:nil];

  //获取跳转界面数据
  NSMutableDictionary *accessToDataMessageDic = [NSMutableDictionary dictionary];
  accessToDataMessageDic[@"action"] = @"get";
  accessToDataMessageDic[@"queries"] = queryDic;
  __weak GDDHeXieViewController *weakSelf = self;
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:accessToDataMessageDic replyHandler:^(id<GDCMessage> message) {
    weakSelf.messageDic = [message body];
    [weakSelf.collectionView reloadData];
    
    if (weakSelf.selectedDic) {
      NSString *classStr = weakSelf.selectedDic[@"queries"][@"type"];
      //迭代查找元素位置
      [self.queryConditionList enumerateObjectsUsingBlock:^(id objComponent, NSUInteger component, BOOL *stopA)
      {
        [objComponent enumerateObjectsUsingBlock:^(id objRow, NSUInteger row, BOOL *stopB){
        
          if([objRow localizedCaseInsensitiveCompare:classStr] == NSOrderedSame){
            [weakSelf.searchPicker selectRow:row inComponent:component animated:YES];
            [weakSelf pickerView:weakSelf.searchPicker didSelectRow:row inComponent:component];
          }
        }];
        
      }];
      weakSelf.selectedDic = nil;
    }
    
  }];
}
#pragma mark -picker view delegate datasouce
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  
  NSString *selectTag = self.queryConditionList[component][row];
  self.pathList[component] = selectTag;

  for (NSInteger i = [self.queryConditionList count] - 1; i > component ; i--) {
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
    return [(NSArray *)self.queryConditionList[component] count];
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
  if (!self.messageDic[@"activities"] || self.messageDic[@"activities"] == [NSNull null]) {
    return 0;
  }
  return [(NSArray *)self.messageDic[@"activities"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  GDDFolderCell *cell = (GDDFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GDDFolderCell" forIndexPath:indexPath];
  cell.titleLabel.text = @"";
  if ([(NSArray *)self.messageDic[@"activities"] count] > 0) {
    cell.titleLabel.text = self.messageDic[@"activities"][indexPath.row][@"title"];
  }
  return cell;
}

@end
