//
//  GDDLocationTableViewController.m
//  GDDrive
//
//  Created by 大黄 on 14-2-13.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDLocationTableViewController.h"

@interface GDDLocationTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *bindData;
@end

@implementation GDDLocationTableViewController

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
  self.bindData = [NSMutableDictionary dictionaryWithDictionary:@{@"networkType": @"",
                                                                  @"mobileCountryCode": @"",
                                                                  @"mobileNetworkCode": @"",
                                                                  @"locationAreaCode": @"",
                                                                  @"cellId": @"",
                                                                  @"PSC": @"",
                                                                  @"BID": @"",
                                                                  @"NID": @"",
                                                                  @"SID": @"",
                                                                  @"Latitude": @"",
                                                                  @"Longitude": @""}];

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
-(void)bindData:(NSDictionary *)data{
  for (NSString *key in [self.bindData allKeys]) {
    NSString *value = @"";
    if (data[key]) {
      value = data[key];
    }
    self.bindData[key] = value;
  }
  [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.bindData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  NSString *text = [NSString stringWithFormat:@"%@ : %@",[self.bindData allKeys][indexPath.row],self.bindData [[self.bindData allKeys][indexPath.row]]];
  cell.textLabel.text = text;
  return cell;
}

@end
