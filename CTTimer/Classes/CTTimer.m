//
//  CTTimer.m
//  Pods
//
//  Created by wshaolin on 16/7/5.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTTimer.h"

typedef NS_ENUM(NSInteger, CTTimerInstanceMethod) {
    CTTimerInstanceMethodInitializer    = 0,
    CTTimerInstanceMethodTimer          = 1,
    CTTimerInstanceMethodScheduledTimer = 2
};

@interface CTTimer(){
    NSTimer *_timer;
}

@end

@implementation CTTimer

+ (instancetype)taskTimerWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData{
    CTTimer *timer = [self timerWithInvocation:invocation timerData:timerData];
    [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    return timer;
}

+ (instancetype)timerWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData{
    return [[self alloc] initWithMethod:CTTimerInstanceMethodTimer invocation:invocation timerData:timerData];
}

+ (instancetype)scheduledTimerWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData{
    return [[self alloc] initWithMethod:CTTimerInstanceMethodScheduledTimer invocation:invocation timerData:timerData];
}

- (instancetype)initWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData{
    return [self initWithMethod:CTTimerInstanceMethodInitializer invocation:invocation timerData:timerData];
}

- (instancetype)initWithMethod:(CTTimerInstanceMethod)mothed
                    invocation:(CTInvocation *)invocation
                     timerData:(CTTimerData *)timerData{
    NSParameterAssert(invocation);
    NSParameterAssert(timerData);
    if(mothed == CTTimerInstanceMethodInitializer){
        NSParameterAssert(timerData.fireDate);
    }
    
    if(self = [super init]){
        _isSuspended = NO;
        [invocation setExecutor:self];
        
        switch (mothed) {
            case CTTimerInstanceMethodTimer:{
                _timer = [NSTimer timerWithTimeInterval:timerData.interval
                                                 target:invocation
                                               selector:@selector(invoke)
                                               userInfo:timerData.userInfo
                                                repeats:timerData.repeats];
            }
                break;
            case CTTimerInstanceMethodScheduledTimer:{
                _timer = [NSTimer scheduledTimerWithTimeInterval:timerData.interval
                                                          target:invocation
                                                        selector:@selector(invoke)
                                                        userInfo:timerData.userInfo
                                                         repeats:timerData.repeats];
            }
                break;
            case CTTimerInstanceMethodInitializer:{
                _timer = [[NSTimer alloc] initWithFireDate:timerData.fireDate
                                                  interval:timerData.interval
                                                    target:invocation
                                                  selector:@selector(invoke)
                                                  userInfo:timerData.userInfo
                                                   repeats:timerData.repeats];
            }
                break;
            default:
                break;
        }
    }
    
    return self;
}

+ (instancetype)taskTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                   target:(id)target
                                 selector:(SEL)selector
                                 userInfo:(id)userInfo
                                  repeats:(BOOL)repeats{
    CTTimerData *timerData = [CTTimerData dataWithInterval:timeInterval repeats:repeats];
    timerData.userInfo = userInfo;
    CTInvocation *invocation = [CTInvocation invocationWithTarget:target action:selector];
    return [self taskTimerWithInvocation:invocation timerData:timerData];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats{
    CTTimerData *timerData = [CTTimerData dataWithInterval:timeInterval repeats:repeats];
    timerData.userInfo = userInfo;
    CTInvocation *invocation = [CTInvocation invocationWithTarget:target action:selector];
    return [self scheduledTimerWithInvocation:invocation timerData:timerData];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval
                               target:(id)target
                             selector:(SEL)selector
                             userInfo:(id)userInfo
                              repeats:(BOOL)repeats{
    CTTimerData *timerData = [CTTimerData dataWithInterval:timeInterval repeats:repeats];
    timerData.userInfo = userInfo;
    CTInvocation *invocation = [CTInvocation invocationWithTarget:target action:selector];
    return [self timerWithInvocation:invocation timerData:timerData];
}

- (instancetype)initWithFireDate:(NSDate *)fireDate
                        interval:(NSTimeInterval)timeInterval
                          target:(id)target
                        selector:(SEL)selector
                        userInfo:(id)userInfo
                         repeats:(BOOL)repeats{
    CTTimerData *timerData = [CTTimerData dataWithInterval:timeInterval repeats:repeats];
    timerData.userInfo = userInfo;
    timerData.fireDate = fireDate;
    CTInvocation *invocation = [CTInvocation invocationWithTarget:target action:selector];
    return [self initWithInvocation:invocation timerData:timerData];
}

- (NSDate *)fireDate{
    return _timer.fireDate;
}

- (void)setFireDate:(NSDate *)fireDate{
    _timer.fireDate = fireDate;
}

- (NSTimeInterval)timeInterval{
    return _timer.timeInterval;
}

- (void)setTolerance:(NSTimeInterval)tolerance{
    _timer.tolerance = tolerance;
}

- (NSTimeInterval)tolerance{
    return _timer.tolerance;
}

- (BOOL)isValid{
    return _timer.isValid;
}

- (id)userInfo{
    return _timer.userInfo;
}

- (void)fire{
    [_timer fire];
    _isSuspended = NO;
}

- (void)invalidate{
    [_timer invalidate];
    _isSuspended = NO;
}

- (void)pause{
    if(_timer.isValid){
        _timer.fireDate = [NSDate distantFuture];
        _isSuspended = YES;
    }
}

- (void)resume{
    if(_timer.isValid){
        _timer.fireDate = [NSDate date];
    }
    
    _isSuspended = NO;
}

- (void)addToRunLoop:(NSRunLoop *)runLoop forMode:(NSString *)mode{
    NSParameterAssert(runLoop);
    NSParameterAssert(mode);
    
    if(_timer == nil){
        return;
    }
    
    if([mode isEqualToString:NSDefaultRunLoopMode] || [mode isEqualToString:NSRunLoopCommonModes]){
        [runLoop addTimer:_timer forMode:mode];
    }
}

- (void)dealloc{
    [_timer invalidate];
    
    _timer = nil;
}

@end

@implementation CTTimerData

+ (instancetype)dataWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats{
    return [[self alloc] initWithInterval:interval repeats:repeats];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats{
    if(self = [super init]){
        _interval = interval;
        _repeats = repeats;
    }
    
    return self;
}

@end
