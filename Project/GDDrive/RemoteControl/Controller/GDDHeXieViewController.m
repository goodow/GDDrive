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
@property (nonatomic, strong) NSDictionary *searchPickerDic;
@property (nonatomic, strong) NSDictionary *messageDic;

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
  
  self.searchPickerDic = @{@"grade":@[@"小班",@"中班",@"大班",@"学前"],@"term":@[@"上",@"下"],@"topic":@[@"健康",@"语言",@"社会",@"科学",@"数学",@"艺术(音乐)",@"艺术(美术)"]};
  self.bus = [GDDBusProvider BUS];
  
}
-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  __weak GDDHeXieViewController *weakSelf = self;
  [self handlerEventBusOpened];
  self.localOpenHandlerRegistration = [self.bus registerHandler:[GDCBus LOCAL_ON_OPEN] handler:^(id<GDCMessage> message) {
    //网络恢复和良好 解除模态
    
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
  
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:@{@"action":@"post",@"query":@{@"type":@"和谐"}} replyHandler:nil];
  
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:@{@"action":@"get",@"query":@{@"type":@"和谐",@"grade":@"小",@"term":@"上",@"topic":@"语言"}} replyHandler:^(id<GDCMessage> message) {
    NSLog(@"%@",message);
    self.messageDic = [message body];
    [self.collectionView reloadData];
  }];
  
  [self.bus send:[GDDAddr FILE:GDDAddrSendRemote] message:@{@"path":@"goodow/drive"} replyHandler:^(id<GDCMessage> message) {
    NSLog(@"%@",message);
//    self.messageDic = [message body];
  }];
}

#pragma mark -picker view delegate datasouce
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  if (component == 0) {
    [[self.searchPickerDic objectForKey:@"grade"] objectAtIndex:row];
  }else if (component == 1){
    [[self.searchPickerDic objectForKey:@"term"] objectAtIndex:row];
  }else if (component == 2){
    [[self.searchPickerDic objectForKey:@"topic"] objectAtIndex:row];
  }
  
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  if (component == 0) {
    return [[self.searchPickerDic objectForKey:@"grade"] count];
  }else if (component == 1){
    return [[self.searchPickerDic objectForKey:@"term"] count];
  }else if (component == 2){
    return [[self.searchPickerDic objectForKey:@"topic"] count];
  }
  return 0;
  
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  if (component == 0) {
    return [[self.searchPickerDic objectForKey:@"grade"] objectAtIndex:row];
  }else if (component == 1){
    return [[self.searchPickerDic objectForKey:@"term"] objectAtIndex:row];
  }else if (component == 2){
    return [[self.searchPickerDic objectForKey:@"topic"] objectAtIndex:row];
  }
  return @"";
}

#pragma mark - collection view delegate and datasouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  // 每个Section的item个数
  return [[self.messageDic objectForKey:@"activities"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  GDDFolderCell *cell = (GDDFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GDDFolderCell" forIndexPath:indexPath];
  cell.titleLabel.text = @"";
  if ([[self.messageDic objectForKey:@"activities"] count] > 0) {
    cell.titleLabel.text = [[(NSArray *)[self.messageDic objectForKey:@"activities"] objectAtIndex:indexPath.row]objectForKey:@"title"];
    
  }
  return cell;
}

@end
