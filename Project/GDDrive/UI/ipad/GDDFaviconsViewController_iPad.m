//
//  GDDFaviconsViewController_iPad.m
//  GDDrive
//
//  Created by 大黄 on 13-10-25.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDFaviconsViewController_iPad.h"

@interface GDDFaviconsViewController_iPad ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation GDDFaviconsViewController_iPad

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;//section == 0 ? [self.folderList length] : [self.filesList length];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  
  return section == 0 ? @"文件夹" : @"文件";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CollaborativeListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
//  if (indexPath.section == 0) {
//    if ([self.folderList length]>0) {
//      GDRCollaborativeMap *map = [self.folderList get:indexPath.row];
//      cell.textLabel.text = [map get:@"label"];
//    }
//    return cell;
//  }else{
//    if ([self.filesList length]>0) {
//      GDRCollaborativeMap *map = [self.filesList get:indexPath.row];
//      cell.textLabel.text = [map get:@"label"];
//    }
//    return cell;
//  }
  
  return cell;
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
