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

@end

@implementation GDDRealtimeDataToViewController

-(id)initWithObjectsAndKeys:(id)objectsAndKeys, ... {
  
  if (self = [super init]) {
    self.argsDictionary = [[NSMutableDictionary alloc] init];
    va_list params;
    va_start(params,objectsAndKeys);
    id arg;
    if (objectsAndKeys) {
      id prev = objectsAndKeys;
      arg = va_arg(params,id);
      [self.argsDictionary setObject:prev forKey:arg];
      while( (arg = va_arg(params,id)) )
      {
        if ( arg ){
          id obj = arg;
          id key = arg =  va_arg(params,id);
          [self.argsDictionary setObject:obj forKey:key];
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
  self.viewControllerProtocol = [self.argsDictionary objectForKey:[strings lastObject]];
  [self.viewControllerProtocol loadRealtimeData:mod];
  
}

@end
