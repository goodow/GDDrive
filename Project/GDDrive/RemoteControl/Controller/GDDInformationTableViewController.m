//
//  GDDInformationViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-2-13.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDInformationTableViewController.h"

@interface GDDInformationTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *bindData;
@end

@implementation GDDInformationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.bindData = [NSMutableDictionary dictionaryWithDictionary:@{@"hardware": @{@"MAC": @"",
                                                                                 @"IMEI": @"",
                                                                                 @"SCREENHEIGH": @"",
                                                                                 @"SCREENWIDTH": @"",},
                                                                  @"software": @{@"AndroidId": @"",
                                                                                 @"IP": @"",
                                                                                 @"Model": @"",
                                                                                 @"Version": @"",
                                                                                 @"SDK": @""}
                                                                  }];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
-(void)bindData:(NSDictionary *)data{
  for (NSString *key in [self.bindData allKeys]) {
    NSDictionary *dic = data[key];
    NSMutableDictionary *changeDic = [NSMutableDictionary dictionaryWithDictionary:self.bindData[key]];
    for (NSString *childKey in dic) {
      NSString *value = @"";
      if (dic[childKey]) {
        value = dic[childKey];
        changeDic[childKey] = value;
      }
    }

    self.bindData[key] = changeDic;
  }
  [self.tableView reloadData];
  
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  return section ? @"software":@"hardware";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return section ? [self.bindData[@"software"]count]:[self.bindData[@"hardware"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  NSString *key = [self.bindData[[self.bindData allKeys][indexPath.section]]allKeys][indexPath.row];
  NSString *value = self.bindData[[self.bindData allKeys][indexPath.section]][key];
  NSString *text = [NSString stringWithFormat:@"%@ : %@",key,value];
  cell.textLabel.text = text;
  return cell;
}
@end
