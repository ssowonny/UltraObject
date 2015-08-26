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
#import <JSONModel/JSONKeyMapper.h>
#import <objc/runtime.h>

static NSMutableDictionary *__idProperties;

@interface UOObject ()
@property (nonatomic, strong) UOID __id;
+ (NSString *)__idProperty;
@end

@implementation UOObject
@synthesize __id;

- (UOID)__id {
    if (!__id && self.class.__idProperty) {
        NSString *getter = self.class.__idProperty;
        NSAssert([self respondsToSelector:NSSelectorFromString(getter)],
                 ([NSString stringWithFormat:@"`%@` should be implemented.", getter, nil]));
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        __id = [self performSelector:NSSelectorFromString(getter)];
#pragma clang diagnostic pop
    }
    
    return __id;
}

- (void)set__id:(UOID)ID {
    NSAssert(!__id, @"Identifier shouldn't be modified.");
    
    if (!self.class.__idProperty) {
        return;
    }
    
    NSString *firstName = [self.class.__idProperty stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                     withString:[[self.class.__idProperty substringToIndex:1] uppercaseString]];
    NSString *setter = [NSString stringWithFormat:@"set%@:", firstName];
    NSAssert([self respondsToSelector:NSSelectorFromString(setter)],
             ([NSString stringWithFormat:@"`%@` should be implemented.", setter, nil]));
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(setter) withObject:ID];
#pragma clang diagnostic pop
}

+ (NSArray *)objectsWithJSONArray:(NSArray *)jsonArray {
    return [self.class arrayOfModelsFromDictionaries:jsonArray];
}

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
    UOID ID = nil;
    NSString *idKey = self.class.__idKey;
    if (!idKey || !(ID = dict[idKey])) {
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

- (void)addObserverTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] addObserverWithTarget:target action:action object:self];
}

- (void)removeObserverTarget:(id)target action:(SEL)action {
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

+ (NSString *)__idProperty {
    if (!__idProperties) {
        __idProperties = [NSMutableDictionary new];
    }
    
    NSString *className = NSStringFromClass(self);
    NSString *idProperty = __idProperties[className];
    
    if (!idProperty) {
        Class class = self.class;
        while (class != [UOObject class] && !idProperty) {
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; i++) {
                objc_property_t property = properties[i];
                const char *attrs = property_getAttributes(property);
                NSString* propertyAttributes = @(attrs);
                if ([propertyAttributes containsString:@"<UOIdentifier>"]
                    && ![propertyAttributes containsString:@"<UONoIdentifier>"]) {
                    const char *propertyName = property_getName(property);
                    idProperty = @(propertyName);
                    break;
                }
            }
            
            free(properties);
            class = [class superclass];
        }
        
        if (!idProperty) {
            idProperty = (id)[NSNull null];
        }
        __idProperties[className] = idProperty;
    }
    
    return idProperty == (id)[NSNull null] ? nil : idProperty;
}

@end

@implementation UOObject (Protected)

+ (Class)UOClass {
    return [self conformsToProtocol:@protocol(UOMutableObject)]
        ? self.superclass : self;
}

+ (NSString *)__idKey {
    NSString *idProperty = self.__idProperty;
    if (!idProperty) {
        return nil;
    }
    
    JSONKeyMapper *keyMapper = self.keyMapper;
    if (keyMapper) {
        return [keyMapper convertValue:idProperty isImportingToModel:NO];
    }
    
    // TODO Should support global key mapper
    
    return idProperty;
}

- (Class)UOClass {
    return [self.class conformsToProtocol:@protocol(UOMutableObject)]
        ? self.superclass : self.class;
}

- (instancetype)initWithID:(UOID)ID {
    self = [super init];
    if (self) {
        self.__id = ID;
    }
    return self;
}

- (BOOL)importDictionary:(NSDictionary*)dict {
    return [self __importDictionary:dict withKeyMapper:self.__keyMapper validation:NO error:nil];
}

@end

@protocol UOIdentifier <NSObject>
@end

@protocol UONoIdentifier <NSObject>
@end