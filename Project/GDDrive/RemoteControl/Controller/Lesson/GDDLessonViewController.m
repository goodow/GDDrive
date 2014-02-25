//
//  GDDLessonViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-1-2.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDLessonViewController.h"
#import "GDDBusProvider.h"
#import "GDDFolderCell.h"
#import "GDDAddr.h"
#import "GDDLessonModel.h"

@interface GDDLessonViewController ()
@property (nonatomic, strong) id <GDCBus> bus;
@property (nonatomic, weak) IBOutlet UIPickerView *searchPicker;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) GDDLessonModel *lessonModel;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichClassHandlerRegistration;
@end

@implementation GDDLessonViewController

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
  self.navigationItem.title = @"课程辅助资源";
  [self.collectionView registerClass:[GDDFolderCell class] forCellWithReuseIdentifier:@"GDDFolderCell"];
  self.bus = [GDDBusProvider BUS];
  self.lessonModel = [[GDDLessonModel alloc]init];
  self.lessonModel.attachmentTags = [NSMutableArray array];
  self.lessonModel.selectedLesson = [self.lessonModel resourceInit];
  [self recordResourceTag];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  __weak GDDLessonViewController *weakSelf = self;
  // 接收控制信息回调 根据数据跳转
  self.swichClassHandlerRegistration = [self.bus registerHandler:[GDDAddr SWITCH_CLASS:GDDAddrReceive] handler:^(id <GDCMessage> message){
    do {
      // 空数据 情况直接跳出整个循环
      if ([[message body][@"tags"] count] == 0) {
        return;
      }
      // 对于课程标签更改 并重置后续的同级条件
      //查询课程标题
      for (int i = 0; i < [[message body][@"tags"] count]; i++) {
        if (![weakSelf.lessonModel.lessonNames containsObject:[message body][@"tags"][i]]) {
          continue;
        }
        weakSelf.lessonModel.selectedLesson = [message body][@"tags"][i];
      }
      [weakSelf.searchPicker selectRow:[[self.lessonModel lessonNames]indexOfObject:weakSelf.lessonModel.selectedLesson] inComponent:0 animated:YES];
      [weakSelf.searchPicker reloadAllComponents];
      break;
    } while (YES);
    NSInteger tag = 0;
    do {
      NSDictionary *resourceStructureDictionary = [self.lessonModel resourceStructure];
      NSArray *resourceTagArray =  resourceStructureDictionary[self.lessonModel.selectedLesson];
      if ([resourceTagArray count] <= tag) {
        break;
      }
      //对于实际数据模型和本地数据模型不一致通过+1调整
      if ([[message body][@"tags"] count] <= tag+1) {
        break;
      }
      NSArray *arr = resourceTagArray [tag];
      for (int i = 0; i < [[message body][@"tags"] count]; i++) {
        if (![arr containsObject:[message body][@"tags"][i]]) {
          continue;
        }
        NSString *tagName = [message body][@"tags"][i];
        NSInteger tagIndex = [arr indexOfObject:tagName];
        [weakSelf.searchPicker selectRow:tagIndex inComponent:tag+1 animated:YES];
      }
      tag++;
    } while (YES);
    [weakSelf recordResourceTag];
  }];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.swichClassHandlerRegistration unregisterHandler];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

//记录活动层级标签
-(void)recordResourceTag{
  //清空缓存记录
  [self.lessonModel.attachmentTags removeAllObjects];
  NSDictionary *resourceStructureDictionary = [self.lessonModel resourceStructure];
  NSArray *resourceTagArray =  resourceStructureDictionary[self.lessonModel.selectedLesson];
  NSInteger component = 0;
  do {
    NSInteger selecedRow = [self.searchPicker selectedRowInComponent:component];
    if (component != 0) {
      break;
    }
    [self.lessonModel.attachmentTags addObject:[self.lessonModel lessonNames][selecedRow]];
    component ++;
  } while (component < 4);
  do {
    NSInteger selecedRow = [self.searchPicker selectedRowInComponent:component];
    if (component == 0) {
      break;
    }
    if ([resourceTagArray count] <= component - 1) {
      break;
    }
    NSArray *childResourceTagArray =  resourceTagArray[component - 1];
    if ([childResourceTagArray count] <= selecedRow) {
      break;
    }
    [self.lessonModel.attachmentTags addObject:childResourceTagArray[selecedRow]];
    component ++;
  } while (component < 4);
  //链接接口 发送标签组信息
  [self.bus send:[GDDAddr TOPIC:GDDAddrSendRemote] message:@{@"action":@"post", @"tags":self.lessonModel.attachmentTags} replyHandler:nil];
  //查询活动内容
  __weak GDDLessonViewController *weakSelf = self;
  [self.bus send:[GDDAddr TAG_CHILDREN:GDDAddrSendRemote] message:@{@"tags":self.lessonModel.attachmentTags} replyHandler:^(id<GDCMessage> message){
    weakSelf.lessonModel.activityTags = [NSMutableArray arrayWithArray:[message body]];
    [weakSelf.collectionView reloadData];
  }];
}

#pragma mark -picker view delegate datasouce
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  if (component == 0) {
    self.lessonModel.selectedLesson = [self.lessonModel lessonNames][row];
    [self.searchPicker reloadAllComponents];
  }
  [self recordResourceTag];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  NSDictionary *resourceStructureDictionary = [self.lessonModel resourceStructure];
  NSArray *keyArray = [resourceStructureDictionary allKeys];
  NSArray *resourceTagArray =  resourceStructureDictionary[self.lessonModel.selectedLesson];
  if (component) {
    if ([resourceTagArray count] > component - 1) {
      NSArray *childResourceTagArray =  resourceTagArray[component - 1];
      return [childResourceTagArray count];
    }else{
      return 0;
    }
  }else{
    return [keyArray count];
  }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  NSDictionary *resourceStructureDictionary = [self.lessonModel resourceStructure];
  NSArray *resourceTagArray =  resourceStructureDictionary[self.lessonModel.selectedLesson];
  if (component) {
    if ([resourceTagArray count] > component - 1) {
      NSArray *childResourceTagArray =  resourceTagArray[component - 1];
      return childResourceTagArray[row];
    }else{
      return @"";
    }
  }else{
    return [self.lessonModel lessonNames][row];
  }
}

#pragma mark - collection view delegate and datasouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  // 每个Section的item个数
  if ([self.lessonModel.activityTags count] == 0 || !self.lessonModel.activityTags) {
    return 0;
  }
  return [self.lessonModel.activityTags count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  GDDFolderCell *cell = (GDDFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GDDFolderCell" forIndexPath:indexPath];
  cell.titleLabel.text = @"";
  if ([self.lessonModel.activityTags count] > 0) {
    cell.titleLabel.text = self.lessonModel.activityTags[indexPath.row];
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  NSLog(@"didSelectItemAtIndexPath");
}
@end
