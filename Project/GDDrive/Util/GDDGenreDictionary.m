//
//  GDDGenreDictionary.m
//  GDDrive
//
//  Created by 大黄 on 13-11-20.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDGenreDictionary.h"
@interface GDDGenreDictionary()
@property (nonatomic, strong)NSDictionary *genreImageDictionary;
@property (nonatomic, strong)NSDictionary *genreTinyImageDictionary;
@property (nonatomic, strong)NSDictionary *genreLargeImageDictionary;
@property (nonatomic, strong)NSDictionary *genreDictionary;
@end
@implementation GDDGenreDictionary
+ (GDDGenreDictionary *) sharedInstance {
  static GDDGenreDictionary *singletonInstance = nil;
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
                                  @"image/jpeg": @"icon_type_jpg.png",
                                  @"image/png": @"icon_type_png.png",
                                  @"video/mp4": @"icon_type_mp4.png",
                                  @"audio/mp3": @"icon_type_mp3.png",
                                  @"application/pdf": @"icon_type_pdf.png",
                                  @"application/x-shockwave-flash": @"icon_type_swf.png"};
    
    self.genreTinyImageDictionary = @{@"isClass": @"icon_type_class.png",
                                      @"noClass": @"icon_type_folder.png",
                                      @"image/jpeg": @"icon_type_jpg.png",
                                      @"image/png": @"icon_type_png.png",
                                      @"video/mp4": @"icon_type_mp4.png",
                                      @"audio/mp3": @"icon_type_mp3.png",
                                      @"application/pdf": @"icon_type_pdf.png",
                                      @"application/x-shockwave-flash": @"icon_type_swf.png"};
    
    self.genreLargeImageDictionary = @{@"isClass": @"default_type_class.png",
                                       @"noClass": @"default_type_folder.png",
                                       @"image/jpeg": @"default_type_jpg.png",
                                       @"image/png": @"default_type_png.png",
                                       @"video/mp4": @"default_type_mp4.png",
                                       @"audio/mp3": @"default_type_mp3.png",
                                       @"application/pdf": @"default_type_pdf.png",
                                       @"application/x-shockwave-flash": @"default_type_swf.png"};
    
    self.genreDictionary = @{@"image/jpeg": @"jpge",
                             @"image/png": @"png",
                             @"video/mp4": @"mp4",
                             @"audio/mp3": @"mp3",
                             @"application/pdf": @"pdf",
                             @"application/x-shockwave-flash": @"swf"};
    
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
-(NSString *)genreNameByKey:(NSString *)key{
  if (!key) RNAssert(NO, @"genreNameByKey key 为空了");
  return [self.genreDictionary objectForKey:key];
}
@end
