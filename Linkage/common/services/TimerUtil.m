//
//  TimerUtil.m
//  Linkage
//
//  Created by Mac mini on 16/3/18.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "TimerUtil.h"

#define kTotalSecond 60
@interface TimerUtil()
@property (nonatomic,readonly) NSTimer *timer;

@end

@implementation TimerUtil
@synthesize timer = _timer;

+(TimerUtil *)shareInstance
{
    static TimerUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TimerUtil alloc]init];
    });
    return instance;
}

static NSInteger currentSecond;
-(void)timeFire:(NSTimer *)timer
{
    if (currentSecond <= 0) {
        currentSecond = kTotalSecond;
    }
    currentSecond--;
    if (currentSecond == 0) {
        [timer invalidate];
        if (_timer) {
            _timer = nil;
        }
    }
    if (self.block) {
        self.block(currentSecond);
    }
}

-(void)fire
{
    if (!_timer || (_timer && !_timer.isValid)){
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

-(void)invalidate
{
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        if (_timer) {
            _timer = nil;
        }
        currentSecond = kTotalSecond;
    }
}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
