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

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock withObject:(UOObject *)object {
    return [NSString stringWithFormat:@"UOEventObserver#%p#%p", observingBlock, object];
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

- (void)dealloc {
    // It's not necessary to remove the observer from the target,
    // since the observer is associated with the target.
    [[UOEventCenter eventCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)event {
    if (_observingBlock && (!self.object || [event.object isEqual:self.object])) {
        _observingBlock(event.object);
    }
}

- (NSString *)key {
    return [self.class keyForObservingBlock:_observingBlock withObject:_object];
}

@end

