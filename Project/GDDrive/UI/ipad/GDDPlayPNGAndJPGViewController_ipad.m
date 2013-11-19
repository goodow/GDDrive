//
//  GDDPlayPNGAndJPGViewController_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-19.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDPlayPNGAndJPGViewController_ipad.h"
#import "UIImageView+MKNetworkKitAdditions.h"

@interface GDDPlayPNGAndJPGViewController_ipad ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

-(IBAction)cancelButtonListener:(id)sender;
@end

@implementation GDDPlayPNGAndJPGViewController_ipad

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
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.imageView cancelOperation];
  
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)loadMultimediaWith:(GDRCollaborativeMap *)map{
  [self.imageView setImageFromURL:[NSURL URLWithString:GDDMultimediaHeadURL([map get:@"id"])]
                 placeHolderImage:[UIImage imageNamed:@"loading.jpg"]];
}
-(IBAction)cancelButtonListener:(id)sender{
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
