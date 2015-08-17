//
//  UOEventObserver.m
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import "UOEventObserver.h"
#import "UOObject+Protected.h"

@implementation UOEventObserver

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock object:(UOObject *)object {
    return [NSString stringWithFormat:@"UOEventObserver<ObservingBlock: %p><UOObject: %p>", observingBlock, object];
}

+ (NSString *)keyForAction:(SEL)action object:(UOObject *)object {
    return [NSString stringWithFormat:@"UOEventObserver<Action: %p><UOObject: %p>", action, object];
}

- (instancetype)initWithTarget:(id)target observingBlock:(UOObservingBlock)observingBlock object:(UOObject *)object {
    self = [super init];
    if (self) {
        _object = object;
        _klass = object.UOClass;
        _target = target;
        _observingBlock = observingBlock;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target observingBlock:(UOObservingBlock)observingBlock class:(Class)klass {
    self = [super init];
    if (self) {
        _klass = klass;
        _target = target;
        _observingBlock = observingBlock;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action object:(UOObject *)object {
    self = [super init];
    if (self) {
        _object = object;
        _klass = object.UOClass;
        _target = target;
        _action = action;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action class:(Class)klass {
    self = [super init];
    if (self) {
        _klass = klass;
        _target = target;
        _action = action;
    }
    return self;   
}

- (void)dealloc {
    // It's not necessary to remove the observer from the target,
    // since the observer is associated with the target.
    [[UOEventCenter eventCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)event {
    if (self.object && ![event.object isEqual:self.object]) {
        return;
    }
    
    if (_observingBlock) {
        _observingBlock(event.object);
    } else if (_target && _action) {
        IMP imp = [_target methodForSelector:_action];
        void (*func)(id, SEL, UOObject *) = (void *)imp;
        func(_target, _action, event.object);
    }
}

- (NSString *)key {
    return _observingBlock
        ? [self.class keyForObservingBlock:_observingBlock object:_object]
        : [self.class keyForAction:_action object:_object];
}

@end

