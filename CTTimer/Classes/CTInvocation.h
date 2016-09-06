//
//  CTInvocation.h
//  Pods
//
//  Created by wshaolin on 16/7/7.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

@import Foundation;

typedef void(^CTInvocationActionBlock)(id executor);

@interface CTInvocation : NSObject

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action;
+ (instancetype)invocationWithActionBlock:(CTInvocationActionBlock)actionBlock;

- (instancetype)initWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithActionBlock:(CTInvocationActionBlock)actionBlock;

- (void)setExecutor:(id)executor;

- (void)getArg:(void *)arg atIndex:(NSInteger)index;
- (void)setArg:(void *)arg atIndex:(NSInteger)index;

- (void)invoke;

@end

FOUNDATION_EXPORT NSUInteger const CTInvocationFirstArgumentIndex;
