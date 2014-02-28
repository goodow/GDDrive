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
//#import "GDDLessonModel.h"

@interface GDDLessonViewController ()
@property (nonatomic, weak) IBOutlet UIPickerView *searchPicker;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) id<GDCHandlerRegistration> swichClassHandlerRegistration;
@property (nonatomic, copy) NSMutableArray *activityTags;

@end

@implementation GDDLessonViewController
static NSDictionary *kLessonDictionary;
static NSArray *kLessons;

+(void)initialize{
  
  kLessons = @[@"和谐",@"托班",@"入学准备",@"智能开发",@"电子书",@"示范课"];
  kLessonDictionary = @{kLessons[0]: @[@[@"小班",@"中班",@"大班",@"学前班"],@[@"上学期",@"下学期"],@[@"健康",@"语言",@"社会",@"科学",@"数学",@"艺术(音乐)",@"艺术(美术)"]],
                        kLessons[1]:@[@[@"上学期",@"下学期"]],
                        kLessons[2]: @[@[@"上学期",@"下学期"],@[@"语言",@"思维",@"阅读与书写",@"习惯与学习品质"]],
                        kLessons[3]: @[@[@"小班",@"中班",@"大班",@"学前班"],@[@"上学期",@"下学期"]],
                        kLessons[4]: @[@[@"冰波童话",@"快乐宝贝",@"其它"]],
                        kLessons[5]:  @[@[@"小班",@"中班",@"大班",@"学前班"],@[@"上学期",@"下学期"],@[@"健康",@"语言",@"社会",@"科学",@"数学",@"艺术(音乐)",@"艺术(美术)"]]};
  
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _activityTags = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"课程辅助资源";
  [self.collectionView registerClass:[GDDFolderCell class] forCellWithReuseIdentifier:@"GDDFolderCell"];
}


- (NSString *)intersectionTagFromLocalTags:(NSArray *)localTags toNetTags:(NSSet *)netTags {
  NSMutableSet *intersectSet = [NSMutableSet setWithArray:localTags];
  [intersectSet intersectSet:netTags];
  return [intersectSet anyObject];
}

- (void)changePikerWithComponent:(NSUInteger)component row:(NSUInteger)row {
  [self.searchPicker selectRow:row inComponent:component animated:YES];
  if (component == 0) {
    [self.searchPicker reloadAllComponents];
  }
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  __weak GDDLessonViewController *weakSelf = self;
  // 接收控制信息回调 根据数据跳转
  self.swichClassHandlerRegistration = [[GDDBusProvider BUS] registerHandler:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_CLASS addressStyle:GDDAddrReceive] handler:^(id <GDCMessage> message){
    // 空数据 情况直接跳出整个循环
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:[message body][@"tags"]];
    if (tagArray.count == 0) {
      NSLog(@"ERROR：GDD_LOCAL_ADDR_CLASS 网络返回标签数据为空");
      return;
    }
    NSMutableSet *tags = [NSMutableSet setWithArray:tagArray];
    NSString *validLessonName = [self intersectionTagFromLocalTags:kLessons toNetTags:tags];
    if (validLessonName == nil) {
      NSLog(@"ERROR：GDD_LOCAL_ADDR_CLASS 网络返回的数据中不包含课程名");
      return;
    }
    [tags removeObject:validLessonName];
    [self changePikerWithComponent:0 row:[kLessons indexOfObject:validLessonName]];
    NSArray *validTagArray = kLessonDictionary[validLessonName];
    for (int i=0; i<tags.count; i++) {
      NSArray *validTags = validTagArray[i];
      NSUInteger row = 0;
      NSString *validTag = [self intersectionTagFromLocalTags:validTags toNetTags:tags];
      if (validTags != nil) {
        row = [validTags indexOfObject:validTag];
      }
      [self changePikerWithComponent:i+1 row:row];
    }
    [weakSelf synchronousAttachmentData];
  }];
  [self synchronousAttachmentData];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.swichClassHandlerRegistration unregisterHandler];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
#pragma mark -
-(NSArray *)attachmentTags{
  NSMutableArray *attachmentTags = [NSMutableArray array];
  NSInteger selecedRowOfGroupOne = [self.searchPicker selectedRowInComponent:0];
  [attachmentTags addObject:kLessons[selecedRowOfGroupOne]];
  NSArray *subattachments = kLessonDictionary[kLessons[selecedRowOfGroupOne]];
  for (int i=0; i<subattachments.count; i++) {
    NSInteger selecedRow = [self.searchPicker selectedRowInComponent:i + 1];
    [attachmentTags addObject:subattachments[i][selecedRow]];
  }
  return attachmentTags;
  
}
-(NSString *)currentLessonName{
  NSInteger selecedRowOfGroupOne = [self.searchPicker selectedRowInComponent:0];
  return kLessons[selecedRowOfGroupOne];
}
//记录活动层级标签
-(void)synchronousAttachmentData{
  //链接接口 发送标签组信息
  [[GDDBusProvider BUS] send:[GDDAddr addressProtocol:ADDR_TOPIC addressStyle:GDDAddrSendRemote] message:@{@"action":@"post", @"tags":self.attachmentTags} replyHandler:nil];
  //查询活动内容
  __weak GDDLessonViewController *weakSelf = self;
  [[GDDBusProvider BUS] send:[GDDAddr addressProtocol:ADDR_TAG_CHILDREN addressStyle:GDDAddrSendRemote] message:@{@"tags":self.attachmentTags} replyHandler:^(id<GDCMessage> message){
    _activityTags = [NSMutableArray arrayWithArray:[message body]];
    [weakSelf.collectionView reloadData];
  }];
}

#pragma mark -picker view delegate datasouce
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  if (component == 0) {
    [self.searchPicker reloadAllComponents];
  }
  [self synchronousAttachmentData];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  NSDictionary *resourceStructureDictionary = kLessonDictionary;
  NSArray *keyArray = [resourceStructureDictionary allKeys];
  NSArray *resourceTagArray =  resourceStructureDictionary[self.currentLessonName];
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
  NSDictionary *resourceStructureDictionary = kLessonDictionary;
  NSArray *resourceTagArray =  resourceStructureDictionary[self.currentLessonName];
  if (component) {
    if ([resourceTagArray count] > component - 1) {
      NSArray *childResourceTagArray =  resourceTagArray[component - 1];
      return childResourceTagArray[row];
    }else{
      return @"";
    }
  }else{
    return kLessons[row];
  }
}

#pragma mark - collection view delegate and datasouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  // 每个Section的item个数
  return _activityTags == nil ? 0 : _activityTags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  GDDFolderCell *cell = (GDDFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GDDFolderCell" forIndexPath:indexPath];
  cell.titleLabel.text = @"";
  if (_activityTags.count > 0) {
    cell.titleLabel.text = _activityTags[indexPath.row];
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  NSMutableArray *detailedLabels = [NSMutableArray arrayWithArray:self.attachmentTags];
  [detailedLabels addObject:_activityTags[indexPath.row]];
  [[GDDBusProvider BUS] send:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_TOPIC_ACTIVITY addressStyle:GDDAddrSendLocal ] message:@{@"tags":detailedLabels ,@"title":_activityTags[indexPath.row]} replyHandler:nil];
}
@end
