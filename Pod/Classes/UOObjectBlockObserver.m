//
//  UOObjectBlockObserver.m
//  Pods
//
//  Created by Sungwon Lee on 8/19/15.
//
//

#import "UOObjectBlockObserver.h"
#import "UOObject+Protected.h"
#import "UOEvent.h"

@implementation UOObjectBlockObserver

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock object:(UOObject *)object {
    return [NSString stringWithFormat:@"UOEventObserver<ObservingBlock: %p><UOObject: %p>", observingBlock, object];
}

- (instancetype)initWithTarget:(id)target block:(UOObservingBlock)block object:(UOObject *)object {
    self = [super initWithTarget:target class:object.UOClass];
    if (self) {
        _object = object;
        _observingBlock = block;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target block:(UOObservingBlock)block class:(Class)klass {
    self = [super initWithTarget:target class:klass];
    if (self) {
        _observingBlock = block;
    }
    return self;
}

- (void)onEvent:(NSNotification *)notification {
    [super onEvent:notification];
    
    UOEvent *event = notification.object;
    if (self.object && ![event.object isEqual:self.object]) {
        return;
    }
    
    if (_observingBlock) {
        _observingBlock(event);
    }
}

- (NSString *)key {
    return [self.class keyForObservingBlock:_observingBlock object:_object];
}

@end
