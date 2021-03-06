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
#import "UOObjectBlockObserver.h"
#import "UOObjectActionObserver.h"

const char UOEventObserversKey;
static UOEventCenter *__eventCenter;

@implementation UOEventCenter

+ (UOEventCenter *)eventCenter {
    if (!__eventCenter) {
        __eventCenter = [[UOEventCenter alloc] init];
    }
    
    return __eventCenter;
}

- (UOEventObserver *)addObserverWithTarget:(id)target block:(UOEventBlock)block class:(Class)klass {
    UOEventObserver *eventObserver = [[UOObjectBlockObserver alloc] initWithTarget:target block:block class:klass];
    [self addEventObserver:eventObserver];
    return eventObserver;
}

- (UOEventObserver *)addObserverWithTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object {
    UOEventObserver *eventObserver = [[UOObjectBlockObserver alloc] initWithTarget:target block:block object:object];
    [self addEventObserver:eventObserver];
    return eventObserver;
}

- (UOEventObserver *)addObserverWithTarget:(id)target action:(SEL)action class:(Class)klass {
    UOEventObserver *eventObserver = [[UOObjectActionObserver alloc] initWithTarget:target action:action class:klass];
    [self addEventObserver:eventObserver];
    return eventObserver;
}

- (UOEventObserver *)addObserverWithTarget:(id)target action:(SEL)action object:(UOObject *)object {
    UOEventObserver *eventObserver = [[UOObjectActionObserver alloc] initWithTarget:target action:action object:object];
    [self addEventObserver:eventObserver];
    return eventObserver;
}

- (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block {
    NSString *key = [UOObjectBlockObserver keyForEventBlock:block object:nil];
    [self removeEventObserverForKey:key target:target];
}

- (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object {
    NSString *key = [UOObjectBlockObserver keyForEventBlock:block object:object];
    [self removeEventObserverForKey:key target:target];
}

- (void)removeObserverWithTarget:(id)target action:(SEL)action {
    NSString *key = [UOObjectActionObserver keyForAction:action object:nil];
    [self removeEventObserverForKey:key target:target];
}

- (void)removeObserverWithTarget:(id)target action:(SEL)action object:(UOObject *)object {
    NSString *key = [UOObjectActionObserver keyForAction:action object:object];
    [self removeEventObserverForKey:key target:target];
}

- (void)removeEventObserver:(UOEventObserver *)eventObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:eventObserver name:NSStringFromClass(eventObserver.klass) object:nil];
    
    if (eventObserver.key && eventObserver.target) {
        NSMutableDictionary *eventObservers = [self eventObserversForTarget:eventObserver.target];
        [eventObservers removeObjectForKey:eventObserver.key];
    }
}

- (void)postEventForObject:(UOObject *)object type:(UOEventType)type {
    [self postEventForObject:object type:type userInfo:nil];
}

- (void)postEventForObject:(UOObject *)object type:(UOEventType)type userInfo:(NSDictionary *)userInfo {
    UOEvent *event = [UOEvent new];
    event.object = object;
    event.type = type;
    event.userInfo = userInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass(object.UOClass) object:event];
}

#pragma mark - Private

- (void)addEventObserver:(UOEventObserver *)eventObserver {
    [[NSNotificationCenter defaultCenter] addObserver:eventObserver selector:@selector(onEvent:) name:NSStringFromClass(eventObserver.klass) object:nil];
    
    NSMutableDictionary *eventObservers = [self eventObserversForTarget:eventObserver.target];
    if ([eventObservers objectForKey:eventObserver.key]) {
        [eventObservers removeObjectForKey:eventObserver.key];
    }
    
    [eventObservers setObject:eventObserver forKey:eventObserver.key];
}

- (void)removeEventObserverForKey:(NSString *)key target:(id)target {
    NSMutableDictionary *eventObservers = [self eventObserversForTarget:target];
    UOEventObserver *eventObserver = eventObservers[key];
    [self removeEventObserver:eventObserver];
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