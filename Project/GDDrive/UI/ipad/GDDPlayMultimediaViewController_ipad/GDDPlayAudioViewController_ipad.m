//
//  GDDPlayAudioViewController_ipad.m
//  GDDrive
//
//  Created by 大黄 on 13-11-28.
//  Copyright (c) 2013年 大黄. All rights reserved.
//

#import "GDDPlayAudioViewController_ipad.h"
#import "GDDOffineFilesHelper.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface Track : NSObject <DOUAudioFile>
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;
@end

@implementation Track
- (NSURL *)audioFileURL
{
  return [self url];
}
@end

@interface GDDPlayAudioViewController_ipad ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) IBOutlet UIButton *buttonPlayPause;
@property (nonatomic, strong) IBOutlet UIButton *buttonNext;
@property (nonatomic, strong) IBOutlet UIButton *buttonStop;

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelInfo;
@property (nonatomic, strong) IBOutlet UILabel *labelMisc;

@property (nonatomic, strong) IBOutlet UISlider *sliderProgress;
@property (nonatomic, strong) IBOutlet UISlider *sliderVolume;

- (IBAction)actionPlayPause:(id)sender;
- (IBAction)actionStop:(id)sender;
- (IBAction)actionSliderProgress:(id)sender;
- (IBAction)actionSliderVolume:(id)sender;
-(IBAction)cancelButtonListener:(id)sender;
@end

@implementation GDDPlayAudioViewController_ipad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
+ (void)load
{
  //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
  //    [self initTracks];
  //  });
  
  [DOUAudioStreamer setOptions:[DOUAudioStreamer options] | DOUAudioStreamerRequireSHA256];
}
//initTracks 为前期初始化使用。加载所需要的歌曲队列的URL组
+ (NSArray *)initTracks
{
  static NSArray *tracks = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://douban.fm/j/mine/playlist?type=n&channel=0&context=channel:0%7Cmusician_id:103658&from=mainsite"]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:NULL
                                                     error:NULL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSMutableArray *allTracks = [NSMutableArray array];
    for (NSDictionary *song in [dict objectForKey:@"song"]) {
      Track *track = [[Track alloc] init];
      [track setArtist:[song objectForKey:@"artist"]];
      [track setTitle:[song objectForKey:@"title"]];
      [track setUrl:[NSURL URLWithString:[song objectForKey:@"url"]]];
      [allTracks addObject:track];
    }
    
    tracks = [allTracks copy];
  });
  
  return tracks;
}
- (void)resetStreamer
{
  if (self.streamer != nil) {
    [self.streamer pause];
    [self.streamer removeObserver:self forKeyPath:@"status"];
    [self.streamer removeObserver:self forKeyPath:@"duration"];
    [self.streamer removeObserver:self forKeyPath:@"bufferingRatio"];
    self.streamer = nil;
  }
  
  Track *track = [self.tracks objectAtIndex:self.currentIndex];
  NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.title];
  [self.labelTitle setText:title];
  
  self.streamer = [DOUAudioStreamer streamerWithAudioFile:track];
  [self.streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
  [self.streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
  [self.streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
  
  [self.streamer play];
  
  [self updateBufferingStatus];
  [self setupHintForStreamer];
}
- (void)updateBufferingStatus
{
  [self.labelMisc setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[self.streamer receivedLength] / 1024 / 1024, (double)[self.streamer expectedLength] / 1024 / 1024, [self.streamer bufferingRatio] * 100.0, (double)[self.streamer downloadSpeed] / 1024 / 1024]];
  
  if ([self.streamer bufferingRatio] >= 1.0) {
    NSLog(@"sha256: %@", [self.streamer sha256]);
  }
}
- (void)setupHintForStreamer
{
  NSUInteger nextIndex = self.currentIndex + 1;
  if (nextIndex >= [self.tracks count]) {
    nextIndex = 0;
  }
  
  [DOUAudioStreamer setHintWithAudioFile:[self.tracks objectAtIndex:nextIndex]];
}
- (void)timerAction:(id)timer
{
  if ([self.streamer duration] == 0.0) {
    [self.sliderProgress setValue:0.0f animated:NO];
  }
  else {
    [self.sliderProgress setValue:[self.streamer currentTime] / [self.streamer duration] animated:YES];
  }
}

- (void)updateStatus
{
  switch ([self.streamer status]) {
    case DOUAudioStreamerPlaying:
      [self.labelInfo setText:@"playing"];
      [self.buttonPlayPause setTitle:@"Pause" forState:UIControlStateNormal];
      break;
      
    case DOUAudioStreamerPaused:
      [self.labelInfo setText:@"paused"];
      [self.buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
      break;
      
    case DOUAudioStreamerIdle:
      [self.labelInfo setText:@"idle"];
      [self.buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
      break;
      
    case DOUAudioStreamerFinished:
      [self.labelInfo setText:@"finished"];
      //      [self actionNext:nil];
      break;
      
    case DOUAudioStreamerBuffering:
      [self.labelInfo setText:@"buffering"];
      break;
      
    case DOUAudioStreamerError:
      [self.labelInfo setText:@"error"];
      break;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}
-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)bindWithDataBean:(GDRCollaborativeMap *)map{
  
  
  NSURL *url = nil;
  GDDOffineFilesHelper *offlineFilesHelper = [[GDDOffineFilesHelper alloc]init];
  if ([offlineFilesHelper isAlreadyPresentInTheLocalFileByData:map]) {
    //本地
    NSString* path =[offlineFilesHelper filePathOfHaveDownloadedByData:map];
    url = [NSURL fileURLWithPath:path];
  }else{
    //网络
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",GDDMultimediaHeadURL([map get:@"id"])]];
  };
  NSMutableArray *allTracks = [NSMutableArray array];
  Track *track = [[Track alloc] init];
  [track setArtist:@"未知艺术家"];//艺术家后台还没有对应数据
  [track setTitle:[map get:@"label"]];
  [track setUrl:url];
  [allTracks addObject:track];
  self.tracks = [allTracks copy];
  self.currentIndex = 0;
  [self resetStreamer];
  
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
  [self.sliderVolume setValue:[DOUAudioStreamer volume]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == kStatusKVOKey) {
    [self performSelector:@selector(updateStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kDurationKVOKey) {
    [self performSelector:@selector(timerAction:)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else if (context == kBufferingRatioKVOKey) {
    [self performSelector:@selector(updateBufferingStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}


- (IBAction)actionPlayPause:(id)sender
{
  if ([self.streamer status] == DOUAudioStreamerPaused ||
      [self.streamer status] == DOUAudioStreamerIdle) {
    [self.streamer play];
  }
  else {
    [self.streamer pause];
  }
}

- (IBAction)actionNext:(id)sender
{
  if (++self.currentIndex >= [self.tracks count]) {
    self.currentIndex = 0;
  }

  [self resetStreamer];
}

- (IBAction)actionStop:(id)sender
{
  [self.streamer stop];
}

- (IBAction)actionSliderProgress:(id)sender
{
  [self.streamer setCurrentTime:[self.streamer duration] * [self.sliderProgress value]];
}

- (IBAction)actionSliderVolume:(id)sender
{
  [DOUAudioStreamer setVolume:[self.sliderVolume value]];
}

-(IBAction)cancelButtonListener:(id)sender{
  [self.streamer stop];
  if (self.streamer != nil) {
    [self.streamer pause];
    [self.streamer removeObserver:self forKeyPath:@"status"];
    [self.streamer removeObserver:self forKeyPath:@"duration"];
    [self.streamer removeObserver:self forKeyPath:@"bufferingRatio"];
    self.streamer = nil;
  }
  if (self.timer) {
    [self.timer invalidate];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
