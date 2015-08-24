//
//  UOObject.m
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import "UOObject.h"
#import "UOObjectManager.h"
#import "UOMutableObject.h"
#import "UOObject+Protected.h"
#import "UOObject+JSONModel.h"
#import "UOMutableObject.h"

@interface UOObject ()
@property (nonatomic, strong) UOID id;
@end

@implementation UOObject
@synthesize id;

+ (instancetype)objectWithJSON:(NSDictionary *)json {
    return [[UOObjectManager sharedManager] objectWithClass:self.UOClass forJSON:json];
}

+ (instancetype)objectWithID:(UOID)ID {
    return [[UOObjectManager sharedManager] objectWithClass:self.UOClass forID:ID];
}

+ (instancetype)new:(NSDictionary *)json {
    UOObject *object = [[UOObjectManager sharedManager] objectWithClass:self.UOClass forJSON:json];
    [object postEventWithType:UOEventTypeCreate];
    return object;
}

+ (void)addObserverWithTarget:(id)target block:(UOEventBlock)block {
    [[UOEventCenter eventCenter] addObserverWithTarget:target block:block class:self.UOClass];
}

+ (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block {
    [[UOEventCenter eventCenter] removeObserverWithTarget:target block:block];
}

+ (void)addObserverWithTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] addObserverWithTarget:target action:action class:self.UOClass];
}

+ (void)removeObserverWithTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] removeObserverWithTarget:target action:action object:nil];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError**)err {
    UOID ID = dict[UOObjectIDKey];
    if (!ID) {
        return [super initWithDictionary:dict error:err];
    }
    
    UOObject *object = [[UOObjectManager sharedManager] objectWithClass:self.UOClass forID:ID];
    if (object != self) {
        return [object initWithDictionary:dict error:err];
    }
    
    return [super initWithDictionary:dict error:err];
}

- (void)dealloc {
    [[UOObjectManager sharedManager] removeObject:self];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    UOObject *object = [[self.UOClass allocWithZone:zone] init];
    [object importDictionary:[self toDictionary]];
    return object;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    Class mutableClass = [[UOObjectManager sharedManager] mutableClassWithClass:self.UOClass];
    UOObject *mutableObject = [[mutableClass allocWithZone:zone] init];
    [mutableObject importDictionary:[self toDictionary]];
    return mutableObject;
}

- (void)addObserverWithTarget:(id)target block:(UOEventBlock)block {
    [[UOEventCenter eventCenter] addObserverWithTarget:target block:block object:self];
}

- (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block {
    [[UOEventCenter eventCenter] removeObserverWithTarget:target block:block object:self];
}

- (void)addObservingTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] addObserverWithTarget:target action:action object:self];
}

- (void)removeObservingTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] removeObserverWithTarget:target action:action object:self];
}

- (void)postEventWithType:(UOEventType)type {
    [[UOEventCenter eventCenter] postEventForObject:self type:type];
}

- (void)postEventWithType:(UOEventType)type userInfo:(NSDictionary *)userInfo {
    [[UOEventCenter eventCenter] postEventForObject:self type:type userInfo:userInfo];
}

- (void)edit:(UOEditBlock)block {
    UOObject<UOMutableObject> *mutableObject = [self mutableCopy];
    block(mutableObject);
    [mutableObject synchronizeWithObject:self];
}

- (void)destroy {
    [self postEventWithType:UOEventTypeDelete];
}

#pragma mark - Private methods

@end

@implementation UOObject (Protected)

+ (Class)UOClass {
    return [self conformsToProtocol:@protocol(UOMutableObject)]
        ? self.superclass : self;
}

- (Class)UOClass {
    return [self.class conformsToProtocol:@protocol(UOMutableObject)]
        ? self.superclass : self.class;
}

- (instancetype)initWithID:(UOID)ID {
    self = [super init];
    if (self) {
        self.id = ID;
    }
    return self;
}

- (BOOL)importDictionary:(NSDictionary*)dict {
    return [self __importDictionary:dict withKeyMapper:self.__keyMapper validation:NO error:nil];
}

@end