//
//  GDDFileOperateHelper.m
//  GDDrive
//
//  Created by 大黄 on 13-11-22.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDFileOperateHelper.h"

@implementation GDDFileOperateHelper


//访问文件夹
- (void)visitFile
{
  NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachePaths = [paths1 objectAtIndex:0];
  NSLog(@"cachePaths:%@",cachePaths);
  for (NSString *str in paths1) {
    NSLog(@"path:%@",str);
  }
}
//创建和删除文件
- (void)createAndDelFile
{
  //创建文件管理器
  NSFileManager *fileManager = [NSFileManager defaultManager];
  //获取路径
  //参数NSDocumentDirectory要获取那种路径
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
  NSLog(@"documentsDirecrtory:%@",documentsDirectory);
  //更改到待操作的目录下
  [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
  //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
  [fileManager createFileAtPath:@"fileone" contents:nil attributes:nil];
  NSString *str = [documentsDirectory stringByAppendingPathComponent:@"fileone"];
  NSLog(@"str:%@",str);
  BOOL isExsit = [fileManager fileExistsAtPath:str];
  if (isExsit) {
    NSLog(@"文件存在");
  }
  else
  {
    NSLog(@"文件不存在");
  }
  //删除待删除的文件
  [fileManager removeItemAtPath:@"fileone" error:nil];
  NSString *str1 = [documentsDirectory stringByAppendingPathComponent:@"fileone"];
  
  BOOL isExsit1 = [fileManager fileExistsAtPath:str1];
  if (isExsit1) {
    NSLog(@"文件存在");
  }
  else
  {
    NSLog(@"文件不存在");
  }
}

//写入和读取文件
- (void)writeAndreadFile
{
  //写入数据：
  //创建文件管理器
  NSFileManager *fileManager = [NSFileManager defaultManager];
  //获取路径
  //参数NSDocumentDirectory要获取那种路径
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
  NSLog(@"documentsDirecrtory:%@",documentsDirectory);
  //更改到待操作的目录下
  [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
  //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
  [fileManager createFileAtPath:@"fileone" contents:nil attributes:nil];
  NSString *str = [documentsDirectory stringByAppendingPathComponent:@"fileone"];
  NSLog(@"str:%@",str);
  BOOL isExsit = [fileManager fileExistsAtPath:str];
  if (isExsit) {
    NSLog(@"文件存在");
  }
  else
  {
    NSLog(@"文件不存在");
  }
  //获取文件路径
  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"fileone"];
  NSLog(@"path:%@",path);
  //待写入的数据
  NSString *temp = @"Hello friend";
  int data0 = 100000;
  float data1 = 23.45f;
  //创建数据缓冲
  NSMutableData *writer = [[NSMutableData alloc] init];
  //将字符串添加到缓冲中
  [writer appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
  //将其他数据添加到缓冲中
  [writer appendBytes:&data0 length:sizeof(data0)];
  [writer appendBytes:&data1 length:sizeof(data1)];
  //将缓冲的数据写入到文件中
  [writer writeToFile:path atomically:YES];
  
  //读取数据：
  int gData0;
  float gData1;
  NSString *gData2;
  NSData *reader = [NSData dataWithContentsOfFile:path];
  gData2 = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, [temp length])]
                                 encoding:NSUTF8StringEncoding];//得到第一个写入的数据
  [reader getBytes:&gData0 range:NSMakeRange([temp length], sizeof(gData0))];//得到第二个写入的数据
  [reader getBytes:&gData1 range:NSMakeRange([temp length] + sizeof(gData0), sizeof(gData1))];//得到第三个写入的数据
  //NSMakeRange代表数据范围，getBytes从reader中读取指定范围的数据
  NSLog(@"%@，%d,%f",gData2,gData0,gData1);
  //读取工程中的文件：
  //读取数据时，要看待读取的文件原有的文件格式，是字节码还是文本
  //可以以字节码格式，也可以以文本格式去读取
  //用于存放数据的变量，因为是字节，所以是ＵInt8
  UInt8 b = 0;
  //获取文件路径
  NSString *path1 = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"txt"];
  //获取数据
  NSData *reader1 = [NSData dataWithContentsOfFile:path1];
  
  //获取字节的个数
  int length = [reader1 length];
  //获取文本中的字符串
  NSString *ges = [[NSString alloc] initWithData:[reader1 subdataWithRange:NSMakeRange(0, length)] encoding:NSUTF8StringEncoding];
  NSLog(@"%@",ges);
  
  NSLog(@"lenghth:%d",length);
  for(int i = 0; i < length; i++) {
    //读取数据
    [reader getBytes:&b range:NSMakeRange(i, sizeof(b))];
    NSLog(@"——–>data%d:%d", i, b);
  }
}
@end
