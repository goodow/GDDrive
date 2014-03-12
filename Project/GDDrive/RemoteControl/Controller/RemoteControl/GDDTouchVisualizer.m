//
//  GDDTouchVisualizer.m
//  GDDrive
//
//  Created by 大黄 on 14-2-19.
//  Copyright (c) 2014年 大黄. All rights reserved.
//

#import "GDDTouchVisualizer.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static CGFloat const kTouchViewAttentionScale = 3;
static CGFloat const kTouchViewSize = 60;
static CGFloat const kTouchViewAlpha = 0.5;
static NSTimeInterval const kTouchAnimationduration = 0.25;
static GDDTouchVisualizer *touchVisualizer;
@class GDDTouchView;

@interface GDDTouchVisualizer ()

{
  CFMutableDictionaryRef touchViews;
}
@property (nonatomic, strong) UIView *mainView;

+ (GDDTouchVisualizer *)sharedTouchVisualizer;
- (void)showTouches:(NSSet *)touches;

@end

@interface GDDTouchView : UIView
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *attentionView;
@end

@implementation GDDTouchView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if(self)
  {
    [self setupAttentionView];
    [self setupMarkView];
  }
  
  return self;
}

- (void)setupAttentionView
{
  self.attentionView = [[UIView alloc] initWithFrame:self.bounds];
  self.attentionView.layer.cornerRadius = kTouchViewSize/2;
  self.attentionView.layer.borderColor = [UIColor redColor].CGColor;
  self.attentionView.layer.borderWidth = 6;
  self.attentionView.alpha = 0;
  self.attentionView.layer.shadowOpacity = 0.25;
  self.attentionView.layer.shadowOffset = CGSizeMake(1, 1);
  self.attentionView.layer.shadowColor = self.attentionView.layer.borderColor;
  self.attentionView.layer.shadowRadius = 1;
  [self addSubview:self.attentionView];
}

- (void)setupMarkView
{
  self.markView = [[UIView alloc] initWithFrame:self.bounds];
  [self addSubview:self.markView];
  self.markView.backgroundColor = [UIColor whiteColor];
  self.markView.layer.cornerRadius = kTouchViewSize/2;
  self.markView.layer.borderWidth = 2;
  self.markView.layer.borderColor = [UIColor blackColor].CGColor;
  self.markView.layer.shadowOpacity = 0.5;
  self.markView.layer.shadowOffset = CGSizeMake(2, 2);
  self.markView.layer.shadowRadius = 2;
  self.markView.transform = CGAffineTransformMakeScale(0.1, 0.1);
  self.markView.alpha = 0;
}

- (void)show
{
  [UIView animateWithDuration:kTouchAnimationduration
                   animations:^{
                     self.markView.alpha = kTouchViewAlpha;
                     self.markView.transform = CGAffineTransformIdentity;
                     self.attentionView.alpha = 0.75;
                     self.markView.alpha = kTouchViewAlpha;
                   }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:kTouchAnimationduration
                                      animations:^{
                                        self.attentionView.alpha = 0;
                                      }];
                   }];
  
  [UIView animateWithDuration:kTouchAnimationduration*2
                   animations:^{
                     self.attentionView.transform = CGAffineTransformMakeScale(kTouchViewAttentionScale, kTouchViewAttentionScale);
                   }
                   completion:^(BOOL finished) {
                     self.attentionView.alpha = 0;
                     self.attentionView.transform = CGAffineTransformIdentity;
                   }];
}

- (void)hide
{
  [UIView animateWithDuration:kTouchAnimationduration
                   animations:^{
                     self.markView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     self.markView.alpha = 0;
                   }];
}

- (BOOL)isVisible
{
  return self.markView.alpha != 0;
}

@end

@interface UIWindow (TouchVisualizer)
@end

@implementation UIWindow (TouchVisualizer)

- (void)swizzled_sendEvent:(UIEvent *)event
{
  [[GDDTouchVisualizer sharedTouchVisualizer] showTouches:event.allTouches];
  [self swizzled_sendEvent:event];
}

@end

@implementation GDDTouchVisualizer
+ (GDDTouchVisualizer *)sharedTouchVisualizer
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    touchVisualizer = [[GDDTouchVisualizer alloc] init];
  });
  
  return touchVisualizer;
}

- (id)init
{
  if(self = [super init]){
  }
  return self;
}
- (void)showTouches:(NSSet *)touches
{
  for(UITouch *touch in touches)
  {
    [self showTouch:touch];
  }
}

- (void)showTouch:(UITouch *)touch
{
  GDDTouchView *touchView;
  CGPoint location;
  
  location = [touch locationInView:self.mainView];
  
  if (location.x < self.mainView.bounds.origin.x) {
    location.x = self.mainView.bounds.origin.x;
  }
  if (location.x > self.mainView.bounds.origin.x + self.mainView.bounds.size.width) {
    location.x = self.mainView.bounds.origin.x + self.mainView.bounds.size.width;
  }
  if (location.y < self.mainView.bounds.origin.y) {
    location.y = self.mainView.bounds.origin.y;
  }
  if (location.y > self.mainView.bounds.origin.y + self.mainView.bounds.size.height) {
    location.y = self.mainView.bounds.origin.y + self.mainView.bounds.size.height;
  }
  
  touchView = [self touchViewForTouch:touch];
  touchView.center = location;
  if(![touchView isVisible])
  {
    [touchView show];
  }
  if(touch.phase == UITouchPhaseEnded)
  {
    CFDictionaryRemoveValue(touchViews, (__bridge const void *)(touch));
    [touchView hide];
  }
}

- (void)setupObserver{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
  [[UIApplication sharedApplication].keyWindow addObserver:self forKeyPath:@"rootViewController" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)setupEventHandler
{
  Method original, swizzle;
  
  original = class_getInstanceMethod([UIWindow class], @selector(sendEvent:));
  swizzle = class_getInstanceMethod([UIWindow class], @selector(swizzled_sendEvent:));
  method_exchangeImplementations(original, swizzle);
}
- (void)setupMainView:(UIView *)view
{
  touchViews = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);

  self.mainView = [[UIView alloc] initWithFrame:view.bounds];
  self.mainView.backgroundColor = [UIColor clearColor];
  self.mainView.opaque = NO;
  self.mainView.userInteractionEnabled = NO;
  self.mainView.transform = view.transform;
  [view addSubview:self.mainView];
}
-(void)install:(UIView *)view{
  NSLog(@"%f",view.bounds.size.height);
  NSLog(@"%f",view.bounds.size.width);
  NSLog(@"%f",view.bounds.origin.x);
  NSLog(@"%f",view.bounds.origin.y);
  [self setupEventHandler];
  [self setupMainView:view];
  [self setupObserver];
}
-(void)remove{
  [self.mainView removeFromSuperview];
  
  Method original, swizzle;
  original = class_getInstanceMethod([UIWindow class], @selector(sendEvent:));
  swizzle = class_getInstanceMethod([UIWindow class], @selector(swizzled_sendEvent:));
  method_exchangeImplementations(swizzle, original);
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
  [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"rootViewController"];
}
- (GDDTouchView *)touchViewForTouch:(UITouch *)touch
{
  GDDTouchView *touchView;
  
  touchView = (GDDTouchView *)CFDictionaryGetValue(touchViews, (__bridge const void *)(touch));
  if(touchView == nil)
  {
    touchView = [[GDDTouchView alloc] initWithFrame:CGRectMake(0, 0, kTouchViewSize, kTouchViewSize)];
    [self.mainView addSubview:touchView];
    CFDictionaryAddValue(touchViews, (__bridge const void *)(touch), (__bridge const void *)(touchView));
  }
  return touchView;
}

- (void)hideAllTouchViews
{
  CFDictionaryRemoveAllValues(touchViews);
  [self.mainView.subviews makeObjectsPerformSelector:@selector(hide)];
}
#pragma mark - Notifications
- (void)applicationWillResignActiveNotification:(NSNotification *)notification
{
  [[GDDTouchVisualizer sharedTouchVisualizer] hideAllTouchViews];
}

- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification
{
  self.mainView.transform = [UIApplication sharedApplication].keyWindow.rootViewController.view.transform;
}

#pragma mark - KVO Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  self.mainView.transform = [UIApplication sharedApplication].keyWindow.rootViewController.view.transform;
  [self.mainView.superview bringSubviewToFront:self.mainView];
}
@end
