//
//  GDDFavoriteViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-3-3.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDFavoriteViewController.h"
#import "GDDBusProvider.h"
#import "GDDFolderCell.h"
#import "GDDAddr.h"
#import "GDDEditableCellModel.h"


typedef NS_ENUM(NSInteger, ActionTypeEnum) {
  kActionTypeEnumActivity = 0,
  kActionTypeEnumText
};

@interface GDDFavoriteViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) GDDEditableCellModel *tagModel;
@property (nonatomic, strong) GDDEditableCellModel *attachmentModel;
@property (nonatomic, strong) id<GDCHandlerRegistration> addFavoriteHandlerRegistration;
@property (nonatomic, strong) id<GDCHandlerRegistration> deleteFavoriteHandlerRegistration;
@property (nonatomic, assign) ActionTypeEnum currentActionType;
@property (nonatomic, assign) BOOL isEditMode;
@end

@implementation GDDFavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _currentActionType = kActionTypeEnumActivity;
    _isEditMode = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.title = @"我的收藏";
  [self.collectionView registerClass:[GDDFolderCell class] forCellWithReuseIdentifier:@"GDDFolderCell"];
  self.tagModel = [[GDDEditableCellModel alloc]init];
  self.attachmentModel = [[GDDEditableCellModel alloc]init];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(choseAction:)];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  //初始化默认选项数据 默认选项为tag
  [self searchFavorite:@"tag"];
  [[GDDBusProvider sharedInstance] send:[GDDAddr addressProtocol:ADDR_VIEW addressStyle:GDDAddrSendRemote] message:@{@"redirectTo":@"favorite"} replyHandler:nil];
  [self receiveControlFavoriteOptions];
  [self receiveControlDeleteFavoriteContent];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self cancelReceiveControlFavoriteOptions];
  [self cancelReceiveControlDeleteFavoriteContent];
}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}

#pragma mark -receiveListener & cancelReceiveListener
- (void)receiveControlFavoriteOptions{
  __weak GDDFavoriteViewController *weakSelf = self;
  self.addFavoriteHandlerRegistration = [[GDDBusProvider sharedInstance] registerHandler:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_FAVORITE addressStyle:GDDAddrReceive]
                                                                                 handler:^(id <GDCMessage> message){
                                                                                   NSArray *array = [message body][@"tags"];
                                                                                   if ([array containsObject:@"活动"]) {
                                                                                     [weakSelf.segmentedControl setSelectedSegmentIndex:0];
                                                                                     [weakSelf searchFavorite:@"tag"];
                                                                                   }else if ([array containsObject:@"文件"]) {
                                                                                     [weakSelf.segmentedControl setSelectedSegmentIndex:1];
                                                                                     [weakSelf searchFavorite:@"attachment"];
                                                                                   }
                                                                                 }];
}
- (void)cancelReceiveControlFavoriteOptions{
  [self.addFavoriteHandlerRegistration unregisterHandler];
}
- (void)receiveControlDeleteFavoriteContent{
  __weak GDDFavoriteViewController *weakSelf = self;
  self.deleteFavoriteHandlerRegistration =
  [[GDDBusProvider sharedInstance] registerHandler:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_DELETE_FAVORITE_LIST addressStyle:GDDAddrReceive]
                                           handler:^(id <GDCMessage> deleteMessage){
                                             
                                             switch (_currentActionType) {
                                               case kActionTypeEnumActivity:
                                               {
                                                 NSMutableArray *stars = [NSMutableArray array];
                                                 for (int indexRow = 0; indexRow < _tagModel.dataSource.count; indexRow ++) {
                                                   if ([_tagModel selectedTagByIndex:indexRow]) {
                                                     NSLog(@"%@",_tagModel.dataSource[indexRow][@"tag"]);
                                                     NSLog(@"%@",_tagModel.dataSource[indexRow][@"type"]);
                                                     [stars addObject:@{@"key": _tagModel.dataSource[indexRow][@"tag"],@"type":_tagModel.dataSource[indexRow][@"type"]}];
                                                   }
                                                 }
                                                 if (stars.count > 0) {
                                                   [[GDDBusProvider sharedInstance] send:[GDDAddr addressProtocol:ADDR_EDITED_LIST addressStyle:GDDAddrSendRemote] message:@{@"action":@"delete",@"stars":stars} replyHandler:^(id <GDCMessage> statusMessage){
                                                     if ([[statusMessage body][@"status"] isEqualToString:@"ok"]) {
                                                       [weakSelf searchFavorite:@"tag"];
                                                     }
                                                   }];
                                                 }
                                               }break;
                                               case kActionTypeEnumText:
                                               {
                                                 
                                               }break;
                                               default:
                                                 break;
                                             }
                                           }];
}
- (void)cancelReceiveControlDeleteFavoriteContent{
  [self.deleteFavoriteHandlerRegistration unregisterHandler];
}

#pragma mark -Action
- (IBAction)segmentedAction:(id)sender{
  UISegmentedControl* control = (UISegmentedControl*)sender;
  switch (control.selectedSegmentIndex) {
    case kActionTypeEnumActivity:
      _currentActionType = kActionTypeEnumActivity;
      [self searchFavorite:@"tag"];
      [[GDDBusProvider sharedInstance] send:[GDDAddr addressProtocol:ADDR_TOPIC addressStyle:GDDAddrSendRemote] message:@{@"action": @"post", @"tags":@[@"活动"]} replyHandler:nil];
      break;
    case kActionTypeEnumText:
      _currentActionType = kActionTypeEnumText;
      [self searchFavorite:@"attachment"];
      [[GDDBusProvider sharedInstance] send:[GDDAddr addressProtocol:ADDR_TOPIC addressStyle:GDDAddrSendRemote] message:@{@"action": @"post", @"tags":@[@"文件"]} replyHandler:nil];
      break;
    default:
      break;
  }
}

#pragma mark -tag & attachment
- (void)searchFavorite:(NSString *)type{
  __weak GDDFavoriteViewController *weakSelf = self;
  [[GDDBusProvider sharedInstance] send:[GDDAddr addressProtocol:ADDR_FAVORITES_SEARCH addressStyle:GDDAddrSendRemote]
                                message:@{@"type": type}
                           replyHandler:^(id<GDCMessage> message){
                             _tagModel = [[GDDEditableCellModel alloc] initWithDataSource:[message body]];
                             NSArray *messages = _tagModel.dataSource;
                             if (messages.count > 0) {
                               //初始化选中标签 为未选中
                               if (_tagModel.dataSource && [type isEqualToString:@"tag"]) {
                                 _tagModel = [[GDDEditableCellModel alloc]initWithDataSource:[message body]];
                               }else if (_tagModel.dataSource && [type isEqualToString:@"attachment"]) {
                                 _attachmentModel = [[GDDEditableCellModel alloc]initWithDataSource:[message body]];
                               }else{
                                 NSLog(@"ERROR ");
                               }
                             }else{
                               _tagModel = [[GDDEditableCellModel alloc]initWithDataSource:nil];
                               _attachmentModel = [[GDDEditableCellModel alloc]initWithDataSource:nil];
                             }
                             [weakSelf.collectionView reloadData];
                           }];
}

#pragma mark - collection view delegate and datasouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  switch (_currentActionType) {
    case kActionTypeEnumActivity:
      return _tagModel.dataSource.count;
    case kActionTypeEnumText:
      return _attachmentModel.dataSource.count;
    default:
      NSLog(@"ERROR: currentActionType 错误");
      return 0;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  GDDFolderCell *cell = (GDDFolderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GDDFolderCell" forIndexPath:indexPath];
  switch (_currentActionType) {
    case kActionTypeEnumActivity:
      //注意：这里的数组为有序数组，最后的节点为真正的文件名，如果发生异常注意查看 lastObject
      cell.titleLabel.text = [[GDJson parseWithNSString:_tagModel.dataSource[indexPath.row][@"tag"]]lastObject];
      [cell.selectImage setHidden:YES];
      break;
    case kActionTypeEnumText:
      cell.titleLabel.text = _tagModel.dataSource[indexPath.row][@"name"];
      [cell.selectImage setHidden:YES];
      break;
    default:
      break;
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

  GDDFolderCell *cell = (GDDFolderCell *)[collectionView cellForItemAtIndexPath:indexPath];
  switch (_currentActionType) {
    case kActionTypeEnumActivity:
    {
      if (_isEditMode) {
        [_tagModel setSelectedTagByIndex:indexPath.row value:![_tagModel selectedTagByIndex:indexPath.row]];
        [cell.selectImage setHidden:![_tagModel selectedTagByIndex:indexPath.row]];
        
      }else{
        NSString *title = [[GDJson parseWithNSString:_tagModel.dataSource[indexPath.row][@"tag"]]lastObject];
        NSArray *tags = [GDJson parseWithNSString:_tagModel.dataSource[indexPath.row][@"tag"]];
        [[GDDBusProvider sharedInstance] send:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_TOPIC_ACTIVITY addressStyle:GDDAddrSendLocal ] message:@{@"tags":tags ,@"title":title} replyHandler:nil];
      }
    }break;
      
    case kActionTypeEnumText:
    {
      if (_isEditMode) {
        [_attachmentModel setSelectedTagByIndex:indexPath.row value:![_tagModel selectedTagByIndex:indexPath.row]];
        [cell.selectImage setHidden:![_attachmentModel selectedTagByIndex:indexPath.row]];
      }else{
        NSLog(@"播放");
      }
    }break;
    default:
      break;
  }
}

#pragma mark -IBAction
- (IBAction)choseAction:(id)sender{
  _isEditMode = !_isEditMode;
  
  if (_isEditMode) {
    [self setLeftBarButtonItem];
  }else{
    self.navigationItem.leftBarButtonItem = nil;
  }
  [self.tagModel setALLSelectedTagByValue:NO];
  [self.attachmentModel setALLSelectedTagByValue:NO];
}

- (void)setLeftBarButtonItem{
  //缩放图片 为原图片的0.6倍
  UIImage *image = [UIImage imageNamed:@"trash.png"];
  CGFloat scaleSize = 0.6f;
  UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
  [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:scaledImage style:UIBarButtonItemStylePlain target:self action:@selector(trashAction:)];
}

- (IBAction)trashAction:(id)sender{
  [[GDDBusProvider sharedInstance] send:[GDDAddr localAddressProtocol:GDD_LOCAL_ADDR_DELETE_FAVORITE_LIST addressStyle:GDDAddrSendLocal] message:nil replyHandler:nil];
}
@end
