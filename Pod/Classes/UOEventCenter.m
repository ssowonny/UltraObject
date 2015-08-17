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

- (void)addObservingBlock:(UOObservingBlock)observingBlock forClass:(Class)klass withTarget:(id)target {
    UOEventObserver *eventObserver = [UOEventObserver new];
    eventObserver.observingBlock = observingBlock;
    [self addEventObserver:eventObserver forClass:klass withTarget:target];
}

- (void)addObservingBlock:(UOObservingBlock)observingBlock forObject:(UOObject *)object withTarget:(id)target {
    UOEventObserver *eventObserver = [UOEventObserver new];
    eventObserver.observingBlock = observingBlock;
    eventObserver.object = object;
    [self addEventObserver:eventObserver forClass:object.UOClass withTarget:target];
}

- (void)removeObservingBlock:(UOObservingBlock)observingBlock forClass:(Class)klass withTarget:(id)target {
    NSString *key = [UOEventObserver keyForObservingBlock:observingBlock withObject:nil];
    [self removeEventObserverForKey:key forClass:klass withTarget:target];
}

- (void)removeObservingBlock:(UOObservingBlock)observingBlock forObject:(UOObject *)object withTarget:(id)target {
    NSString *key = [UOEventObserver keyForObservingBlock:observingBlock withObject:object];
    [self removeEventObserverForKey:key forClass:object.UOClass withTarget:target];
}

- (void)postEventForObject:(UOObject *)object {
    [self postNotificationName:NSStringFromClass(object.UOClass) object:object];
}

#pragma mark - Private

- (void)addEventObserver:(UOEventObserver *)eventObserver forClass:(Class)klass withTarget:(id)target {
    [self addObserver:eventObserver selector:@selector(onEvent:) name:NSStringFromClass(klass) object:nil];
    
    NSMutableDictionary *eventObservers = [self eventObserversForTarget:target];
    [eventObservers setObject:eventObserver forKey:eventObserver.key];
}

- (void)removeEventObserverForKey:(NSString *)key forClass:(Class)klass withTarget:(id)target {
    NSMutableDictionary *eventObservers = [self eventObserversForTarget:target];
    UOEventObserver *eventObserver = eventObservers[key];
    [self removeObserver:eventObserver name:NSStringFromClass(klass) object:nil];
    
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