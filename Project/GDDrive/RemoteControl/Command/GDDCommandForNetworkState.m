//
//  GDDCommandForNetworkState.m
//  GDDrive
//
//  Created by 大黄 on 14-3-12.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForNetworkState.h"
#import "GDDBusProvider.h"
#import "MRProgressOverlayView.h"
#import "AppDelegate.h"

@implementation GDDCommandForNetworkState
-(void)execute {
  GDCStateEnum *stateEnum = [[GDDBusProvider sharedInstance] getReadyState];
  switch ([stateEnum ordinal]) {
    case GDCState_CONNECTING:
    case GDCState_CLOSED:
    case GDCState_CLOSING:
      NSLog(@"CONNECTING or CLOSING or CLOSED");
      [MRProgressOverlayView showOverlayAddedTo:GDDRemoteControlDelegate.window animated:YES];
      break;
    case GDCState_OPEN:
      NSLog(@"OPEN");
      break;
    default:
      break;
  }
}
@end
