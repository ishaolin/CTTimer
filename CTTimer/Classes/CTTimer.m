//
//  CTTimer.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "CTTimer.h"
#import "CTInvocation.h"

@interface CTTimer(){
    NSTimer *_timer;
}

@end

@implementation CTTimer

+ (instancetype)taskTimerWithConfig:(CTTimerConfigBlock)config{
    CTTimer *timer = [[self alloc] init];
    [timer createForTimerWithConfigBlock:config];
    return timer;
}

+ (instancetype)timerWithConfig:(CTTimerConfigBlock)config{
    CTTimer *timer = [[self alloc] init];
    [timer createForTimerWithConfigBlock:config];
    return timer;
}

+ (instancetype)scheduledTimerWithConfig:(CTTimerConfigBlock)config{
    CTTimer *timer = [[self alloc] init];
    [timer createForScheduledTimerWithConfigBlock:config];
    return timer;
}

- (instancetype)initWithConfig:(CTTimerConfigBlock)config{
    if(self = [super init]){
        [self createForInitTimerWithConfigBlock:config];
    }
    
    return self;
}

- (void)createForTimerWithConfigBlock:(CTTimerConfigBlock)configBlock{
    CTTimerConfig *config = [[CTTimerConfig alloc] init];
    configBlock(config);
    
    CTInvocation *invocation = [CTInvocation invocationWithTarget:config.target action:config.action];
    invocation.invoker = self;
    _timer = [NSTimer timerWithTimeInterval:config.interval
                                     target:invocation
                                   selector:@selector(invoke)
                                   userInfo:config.userInfo
                                    repeats:config.repeats];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)createForScheduledTimerWithConfigBlock:(CTTimerConfigBlock)configBlock{
    CTTimerConfig *config = [[CTTimerConfig alloc] init];
    configBlock(config);
    
    CTInvocation *invocation = [CTInvocation invocationWithTarget:config.target action:config.action];
    invocation.invoker = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:config.interval
                                              target:invocation
                                            selector:@selector(invoke)
                                            userInfo:config.userInfo
                                             repeats:config.repeats];
}

- (void)createForInitTimerWithConfigBlock:(CTTimerConfigBlock)configBlock{
    CTTimerConfig *config = [[CTTimerConfig alloc] init];
    configBlock(config);
    
    NSParameterAssert(config.fireDate);
    
    CTInvocation *invocation = [CTInvocation invocationWithTarget:config.target action:config.action];
    invocation.invoker = self;
    _timer = [[NSTimer alloc] initWithFireDate:config.fireDate
                                      interval:config.interval
                                        target:invocation
                                      selector:@selector(invoke)
                                      userInfo:config.userInfo
                                       repeats:config.repeats];
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
    if(_isSuspended){
        return;
    }
    
    if(_timer.isValid){
        _timer.fireDate = [NSDate distantFuture];
        _isSuspended = YES;
    }
}

- (void)resume{
    if(!_isSuspended){
        return;
    }
    
    if(_timer.isValid){
        _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:_timer.timeInterval];
    }
    
    _isSuspended = NO;
}

- (void)addToRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode{
    NSParameterAssert(runLoop);
    NSParameterAssert(mode);
    
    if(!_timer){
        return;
    }
    
    if([mode isEqualToString:NSDefaultRunLoopMode] || [mode isEqualToString:NSRunLoopCommonModes]){
        [runLoop addTimer:_timer forMode:mode];
    }
}

- (void)dealloc{
    if(_timer.isValid){
        [_timer invalidate];
    }
    
    _timer = nil;
}

@end

@implementation CTTimerConfig

@end
