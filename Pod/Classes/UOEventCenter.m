//
//  UOEventCenter.m
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import "UOEventCenter.h"
#import "UOObject.h"
#import "UOObject+Protected.h"
#import <objc/runtime.h>
#import "UOEventObserver.h"

const char UOEventObserversKey;
static UOEventCenter *__eventCenter;

@implementation UOEventCenter

+ (UOEventCenter *)eventCenter {
    if (!__eventCenter) {
        __eventCenter = [[UOEventCenter alloc] init];
    }
    
    return __eventCenter;
}

- (void)addObservingTarget:(id)target block:(UOObservingBlock)block class:(Class)klass {
    UOEventObserver *eventObserver = [[UOEventObserver alloc] initWithTarget:target observingBlock:block class:klass];
    [self addEventObserver:eventObserver];
}

- (void)addObservingTarget:(id)target block:(UOObservingBlock)block object:(UOObject *)object {
    UOEventObserver *eventObserver = [[UOEventObserver alloc] initWithTarget:target observingBlock:block object:object];
    [self addEventObserver:eventObserver];
}

- (void)addObservingTarget:(id)target action:(SEL)action class:(Class)klass {
    UOEventObserver *eventObserver = [[UOEventObserver alloc] initWithTarget:target action:action class:klass];
    [self addEventObserver:eventObserver];
}

- (void)addObservingTarget:(id)target action:(SEL)action object:(UOObject *)object {
    UOEventObserver *eventObserver = [[UOEventObserver alloc] initWithTarget:target action:action object:object];
    [self addEventObserver:eventObserver];
}

- (void)removeObservingTarget:(id)target block:(UOObservingBlock)observingBlock {
    NSString *key = [UOEventObserver keyForObservingBlock:observingBlock object:nil];
    [self removeEventObserverForKey:key target:target];
}

- (void)removeObservingTarget:(id)target block:(UOObservingBlock)observingBlock object:(UOObject *)object {
    NSString *key = [UOEventObserver keyForObservingBlock:observingBlock object:object];
    [self removeEventObserverForKey:key target:target];
}

- (void)removeObservingTarget:(id)target action:(SEL)action {
    NSString *key = [UOEventObserver keyForAction:action object:nil];
    [self removeEventObserverForKey:key target:target];
}

- (void)removeObservingTarget:(id)target action:(SEL)action object:(UOObject *)object {
    NSString *key = [UOEventObserver keyForAction:action object:object];
    [self removeEventObserverForKey:key target:target];
}

- (void)postEventForObject:(UOObject *)object {
    [self postNotificationName:NSStringFromClass(object.UOClass) object:object];
}

#pragma mark - Private

- (void)addEventObserver:(UOEventObserver *)eventObserver {
    [self addObserver:eventObserver selector:@selector(onEvent:) name:NSStringFromClass(eventObserver.klass) object:nil];
    
    NSMutableDictionary *eventObservers = [self eventObserversForTarget:eventObserver.target];
    [eventObservers setObject:eventObserver forKey:eventObserver.key];
}

- (void)removeEventObserverForKey:(NSString *)key target:(id)target {
    NSMutableDictionary *eventObservers = [self eventObserversForTarget:target];
    UOEventObserver *eventObserver = eventObservers[key];
    [self removeObserver:eventObserver name:NSStringFromClass(eventObserver.klass) object:nil];
    
    [eventObservers removeObjectForKey:key];
}

- (NSMutableDictionary *)eventObserversForTarget:(id)target {
    NSMutableDictionary *eventObservers = objc_getAssociatedObject(target, &UOEventObserversKey);
    if (!eventObservers) {
        eventObservers = [NSMutableDictionary new];
        objc_setAssociatedObject(target, &UOEventObserversKey, eventObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return eventObservers;
}

@end