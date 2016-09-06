//
//  CTTimer.h
//  Pods
//
//  Created by wshaolin on 16/7/5.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTInvocation.h"

@class CTTimerData;

@interface CTTimer : NSObject

@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;
@property (nonatomic, assign, readonly) BOOL isValid;
@property (nonatomic, strong, readonly) id userInfo;

@property (nonatomic, assign, readonly) BOOL isSuspended;
@property (nonatomic, assign) NSTimeInterval tolerance;

+ (instancetype)taskTimerWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData;

+ (instancetype)scheduledTimerWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData;

+ (instancetype)timerWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData;

- (instancetype)initWithInvocation:(CTInvocation *)invocation timerData:(CTTimerData *)timerData;

- (void)fire;
- (void)invalidate;
- (void)pause;
- (void)resume;

- (void)addToRunLoop:(NSRunLoop *)runLoop forMode:(NSString *)mode;

+ (instancetype)taskTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                   target:(id)target
                                 selector:(SEL)selector
                                 userInfo:(id)userInfo
                                  repeats:(BOOL)repeats;

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats;

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval
                               target:(id)target
                             selector:(SEL)selector
                             userInfo:(id)userInfo
                              repeats:(BOOL)repeats;

- (instancetype)initWithFireDate:(NSDate *)fireDate
                        interval:(NSTimeInterval)timeInterval
                          target:(id)target
                        selector:(SEL)selector
                        userInfo:(id)userInfo
                         repeats:(BOOL)repeats;

@end

@interface CTTimerData : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval interval;
@property (nonatomic, assign, readonly) BOOL repeats;

@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) id userInfo;

+ (instancetype)dataWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats;

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats;

@end
