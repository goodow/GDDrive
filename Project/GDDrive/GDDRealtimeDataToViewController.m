//
//  GDDRealtimeDataToViewController.m
//  GDDrive
//
//  Created by 大黄 on 13-11-7.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDRealtimeDataToViewController.h"

@interface GDDRealtimeDataToViewController ()

@property (nonatomic, weak) id <GDRealtimeProtocol> viewControllerProtocol;
@property (nonatomic, strong) NSMutableDictionary *argsDictionary;
@property (nonatomic, strong) NSMutableArray *argsArray;
@property (nonatomic, strong) TransitionFromChildViewControllerToViewControllerBlock transitionFromChildViewControllerToViewControllerBlock;
@end

@implementation GDDRealtimeDataToViewController

-(id)initWithTransitionFromChildViewControllerToViewControllerBlock:(TransitionFromChildViewControllerToViewControllerBlock)block ObjectsAndKeys:(id)objectsAndKeys, ... {
  
  if (self = [super init]) {
    self.transitionFromChildViewControllerToViewControllerBlock = block;
    self.argsDictionary = [[NSMutableDictionary alloc] init];
    self.argsArray = [[NSMutableArray alloc]init];
    va_list params;
    va_start(params,objectsAndKeys);
    id arg;
    if (objectsAndKeys) {
      id prev = objectsAndKeys;
      arg = va_arg(params,id);
      [self.argsDictionary setObject:prev forKey:arg];
      [self.argsArray addObject:arg];
      while( (arg = va_arg(params,id)) )
      {
        if ( arg ){
          id obj = arg;
          id key = arg =  va_arg(params,id);
          [self.argsDictionary setObject:obj forKey:key];
          [self.argsArray addObject:key];
        }
      }
      va_end(params);
    }
  }
  return self;
}

-(void)loadRealtimeData:(GDRModel *)mod{
  GDRCollaborativeMap *root = [mod getRoot];
  GDRCollaborativeMap *path = [root get:@"path"];
  id <GDJsonString> currentdocid = [path get:@"currentdocid"];
  NSArray *strings= [[currentdocid getString] componentsSeparatedByString:@"/"];
  if ([[self.argsDictionary objectForKey:[strings lastObject]] conformsToProtocol:@protocol(GDRealtimeProtocol)]) {
    self.viewControllerProtocol = [self.argsDictionary objectForKey:[strings lastObject]];
    NSInteger index = [self.argsArray indexOfObject:[strings lastObject]];
    self.transitionFromChildViewControllerToViewControllerBlock(index);
    [self.viewControllerProtocol loadRealtimeData:mod];
  }
}

@end
