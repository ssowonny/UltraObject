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

static UOEventCenter *__eventCenter;

@interface UOEventObserver : NSObject
@property (nonatomic, readonly) NSString *key;
@property (nonatomic, strong) UOObservingBlock observingBlock;
@property (nonatomic, weak) UOObject *object;

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock;
- (void)onEvent:(NSNotification *)event;
@end

@implementation UOEventObserver

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock {
    return [NSString stringWithFormat:@"UOEventObserver#%@", observingBlock];
}

- (void)dealloc {
    [[UOEventCenter eventCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)event {
    if (_observingBlock && (!self.object || [event.object isEqual:self.object])) {
        _observingBlock(event.object);
    }
}

- (NSString *)key {
    return [self.class keyForObservingBlock:_observingBlock];
}

@end

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

- (void)removeObservingBlock:(UOObservingBlock)observingBlock forClass:(Class)klass withTarget:(id)target {
    NSString *key = [UOEventObserver keyForObservingBlock:observingBlock];
    UOEventObserver *eventObserver = objc_getAssociatedObject(target, key.UTF8String);
    [self removeObserver:eventObserver name:NSStringFromClass(klass) object:nil];
    
    objc_removeAssociatedObjects(eventObserver);
}

- (void)addObservingBlock:(UOObservingBlock)observingBlock forObject:(UOObject *)object withTarget:(id)target {
    UOEventObserver *eventObserver = [UOEventObserver new];
    eventObserver.observingBlock = observingBlock;
    eventObserver.object = object;
    [self addEventObserver:eventObserver forClass:object.UOClass withTarget:target];
}

- (void)removeObservingBlock:(UOObservingBlock)observingBlock forObject:(UOObject *)object withTarget:(id)target {
    [self removeObservingBlock:observingBlock forClass:object.UOClass withTarget:target];
}

- (void)postEventForObject:(UOObject *)object {
    [self postNotificationName:NSStringFromClass(object.UOClass) object:object];
}

#pragma mark - Private

- (void)addEventObserver:(UOEventObserver *)eventObserver forClass:(Class)klass withTarget:(id)target {
    [self addObserver:eventObserver selector:@selector(onEvent:) name:NSStringFromClass(klass) object:nil];
    objc_setAssociatedObject(target, eventObserver.key.UTF8String, eventObserver, OBJC_ASSOCIATION_RETAIN);
}

@end