//
//  CTInvocation.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
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
    if(!target || !action){
        return nil;
    }
    
    if(![target respondsToSelector:action]){
        return nil;
    }
    
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    if(!methodSignature){
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
    if(!actionBlock){
        return nil;
    }
    
    if(self = [super init]){
        self.actionBlock = actionBlock;
    }
    
    return self;
}

- (void)setExecutor:(id)executor{
    if(_executor == executor){
        return;
    }
    
    _executor = executor;
    if(_invocation && _executor){
        [_invocation setArgument:&_executor atIndex:CTInvocationFirstArgumentIndex];
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
    if(!_invocation){
        return NO;
    }
    
    return index >= CTInvocationFirstArgumentIndex &&
    index < _invocation.methodSignature.numberOfArguments;
}

- (void)invoke{
    if(_invocation){
        [_invocation invoke];
    }else{
        !_actionBlock ?: _actionBlock(_executor);
    }
}

- (void)dealloc{
    _invocation = nil;
    _actionBlock = NULL;
}

@end

NSUInteger const CTInvocationFirstArgumentIndex = 2;
