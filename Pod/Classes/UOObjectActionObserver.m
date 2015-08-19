//
//  UOObjectActionObserver.m
//  Pods
//
//  Created by Sungwon Lee on 8/19/15.
//
//

#import "UOObjectActionObserver.h"
#import "UOObject+Protected.h"

@implementation UOObjectActionObserver

+ (NSString *)keyForAction:(SEL)action object:(UOObject *)object {
    return [NSString stringWithFormat:@"UOObjectActionObserver<Action: %p><UOObject: %p>", action, object];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action object:(UOObject *)object {
    self = [super initWithTarget:target class:object.UOClass];
    if (self) {
        _object = object;
        _action = action;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action class:(Class)klass {
    self = [super initWithTarget:target class:klass];
    if (self) {
        _action = action;
    }
    return self;   
}

- (void)onEvent:(NSNotification *)notification {
    [super onEvent:notification];
    
    UOEvent *event = notification.object;
    if (self.object && ![event.object isEqual:self.object]) {
        return;
    }
    
    if (self.target && _action) {
        IMP imp = [self.target methodForSelector:_action];
        void (*func)(id, SEL, UOEvent *) = (void *)imp;
        func(self.target, _action, event);
    }
}

- (NSString *)key {
    return [self.class keyForAction:_action object:_object];
}

@end
