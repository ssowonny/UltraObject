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

+ (NSString *)keyForEventBlock:(UOEventBlock)eventBlock object:(UOObject *)object {
    return [NSString stringWithFormat:@"UOObjectBlockObserver<UOEventBlock: %p><UOObject: %p>", eventBlock, object];
}

- (instancetype)initWithTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object {
    self = [super initWithTarget:target class:object.UOClass];
    if (self) {
        _object = object;
        _eventBlock = block;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target block:(UOEventBlock)block class:(Class)klass {
    self = [super initWithTarget:target class:klass];
    if (self) {
        _eventBlock = block;
    }
    return self;
}

- (void)onEvent:(NSNotification *)notification {
    [super onEvent:notification];
    
    UOEvent *event = notification.object;
    if (self.object && ![event.object isEqual:self.object]) {
        return;
    }
    
    if (_eventBlock) {
        _eventBlock(event);
    }
}

- (NSString *)key {
    return [self.class keyForEventBlock:_eventBlock object:_object];
}

@end
