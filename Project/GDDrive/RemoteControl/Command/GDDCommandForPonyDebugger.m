//
//  GDDCommandForPonyDebugger.m
//  GDDrive
//
//  Created by 大黄 on 14-3-20.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDCommandForPonyDebugger.h"
#import "PonyDebugger/PDDebugger.h"

@implementation GDDCommandForPonyDebugger
- (void)execute {
  PDDebugger *debugger = [PDDebugger defaultInstance];
  [debugger enableNetworkTrafficDebugging];
  [debugger forwardAllNetworkTraffic];
  // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
  // Choose a few UIView key paths to display as attributes of the dom nodes
  [debugger enableViewHierarchyDebugging];
  [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque", @"accessibilityLabel", @"text"]];
  
  // [debugger connectToURL:[NSURL URLWithString:@"ws://127.0.0.1:9000/device"]];
  [debugger autoConnect];
  // 终端输入 ponyd serve --listen-interface=0.0.0.0
  // 页面打开 http://localhost:9000进行控制
}
@end