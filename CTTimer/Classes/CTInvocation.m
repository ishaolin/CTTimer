//
//  CTInvocation.m
//  Pods
//
//  Created by wshaolin on 16/7/7.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTInvocation.h"

@interface CTInvocation(){
    NSInvocation *_invocation;
    __weak id _executor;
}

@property (nonatomic, assign, readonly) BOOL hasArgs;
@property (nonatomic, copy) CTInvocationActionBlock actionBlock;

@end

@implementation CTInvocation

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action{
    return [[self alloc] initWithTarget:target action:action];
}

+ (instancetype)invocationWithActionBlock:(CTInvocationActionBlock)actionBlock{
    return [[self alloc] initWithActionBlock:actionBlock];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    if(target == nil || action == NULL){
        return nil;
    }
    
    if(![target respondsToSelector:action]){
        return nil;
    }
    
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    if(methodSignature == nil){
        return nil;
    }
    
    if(self = [super init]){
        _invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        _invocation.target = target;
        _invocation.selector = action;
        
        _hasArgs = methodSignature.numberOfArguments > CTInvocationFirstArgumentIndex;
    }
    
    return self;
}

- (instancetype)initWithActionBlock:(CTInvocationActionBlock)actionBlock{
    if(actionBlock == NULL){
        return nil;
    }
    
    if(self = [super init]){
        _hasArgs = NO;
        
        self.actionBlock = actionBlock;
    }
    
    return self;
}

- (void)setExecutor:(id)executor{
    if(_executor != executor){
        _executor = executor;
        
        [self setArg:&_executor atIndex:CTInvocationFirstArgumentIndex];
    }
}

- (void)getArg:(void *)arg atIndex:(NSInteger)index{
    if(self.hasArgs && [self isValidArgIndex:index]){
        [_invocation getArgument:arg atIndex:index];
    }
}

- (void)setArg:(void *)arg atIndex:(NSInteger)index{
    if(self.hasArgs && [self isValidArgIndex:index]){
        [_invocation setArgument:arg atIndex:index];
    }
}

- (BOOL)isValidArgIndex:(NSInteger)index{
    if(_invocation != nil){
        return (index >= CTInvocationFirstArgumentIndex) &&
        (index < _invocation.methodSignature.numberOfArguments);
    }
    
    return NO;
}

- (void)invoke{
    if(_invocation != nil){
        [_invocation invoke];
    }else{
        if(_actionBlock){
            _actionBlock(_executor);
        }
    }
}

- (void)dealloc{
    _invocation = nil;
    _actionBlock = NULL;
}

@end

NSUInteger const CTInvocationFirstArgumentIndex = 2;

