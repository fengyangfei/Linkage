//
//  TimerUtil.m
//  Linkage
//
//  Created by Mac mini on 16/3/18.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "TimerManager.h"

#define kTotalSecond 60
@interface TimerManager()
@property (nonatomic,readonly) NSTimer *timer;

@end

@implementation TimerManager
@synthesize timer = _timer;

+(TimerManager *)shareInstance
{
    static TimerManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TimerManager alloc]init];
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
        [self invalidate];
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
