//
//  GDDGenreImageDictionary.m
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDGenreImageDictionary.h"
@interface GDDGenreImageDictionary()
@property (nonatomic, strong)NSDictionary *genreImageDictionary;
@property (nonatomic, strong)NSDictionary *genreTinyImageDictionary;
@property (nonatomic, strong)NSDictionary *genreLargeImageDictionary;
@end
@implementation GDDGenreImageDictionary
+ (GDDGenreImageDictionary *) sharedInstance {
  static GDDGenreImageDictionary *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

-(id)init{
  if (self = [super init]) {
    
  }
  return self;
}
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    self.genreImageDictionary = @{@"isClass": @"class_icon.png",
                                  @"noClass": @"offline_files_icon.png",
                                  @"image/jpeg": @"favicons_icon.png",
                                  @"image/png": @"favicons_icon.png",
                                  @"video/mp4": @"favicons_icon.png",
                                  @"video/mp3": @"favicons_icon.png",
                                  @"application/pdf": @"favicons_icon.png",
                                  @"application/x-shockwave-flash": @"favicons_icon.png"};
    
    self.genreTinyImageDictionary = @{@"isClass": @"icon_type_class.png",
                                      @"noClass": @"icon_type_folder.png",
                                      @"image/jpeg": @"icon_type_jpg.png",
                                      @"image/png": @"icon_type_png.png",
                                      @"video/mp4": @"icon_type_mp4.png",
                                      @"video/mp3": @"icon_type_mp3.png",
                                      @"application/pdf": @"icon_type_pdf.png",
                                      @"application/x-shockwave-flash": @"icon_type_swf.png"};
    
    self.genreLargeImageDictionary = @{@"isClass": @"default_type_class.png",
                                       @"noClass": @"default_type_folder.png",
                                       @"image/jpeg": @"default_type_jpg.png",
                                       @"image/png": @"default_type_png.png",
                                       @"video/mp4": @"default_type_mp4.png",
                                       @"video/mp3": @"default_type_mp3.png",
                                       @"application/pdf": @"default_type_pdf.png",
                                       @"application/x-shockwave-flash": @"default_type_swf.png"};
    
  }
  return self;
}
-(NSString *)imageNameByKey:(NSString *)key{
  if (!key) RNAssert(NO, @"imageNameByKey key 为空了");
  return [self.genreImageDictionary objectForKey:key];
}
-(NSString *)tinyImageNameByKey:(NSString *)key{
  if (!key) RNAssert(NO, @"imageNameByKey key 为空了");
  return [self.genreTinyImageDictionary objectForKey:key];
}
-(NSString *)largeImageNameByKey:(NSString *)key{
  if (!key) RNAssert(NO, @"imageNameByKey key 为空了");
  return [self.genreLargeImageDictionary objectForKey:key];
}
@end
