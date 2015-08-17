//
//  UOObject.m
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import "UOObject.h"
#import "NSString+Conversion.h"
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

+ (void)addObservingTarget:(id)target block:(UOObservingBlock)block {
    [[UOEventCenter eventCenter] addObservingTarget:target block:block class:self.UOClass];
}

+ (void)removeObservingTarget:(id)target block:(UOObservingBlock)block {
    [[UOEventCenter eventCenter] removeObservingTarget:target block:block];
}

+ (void)addObservingTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] addObservingTarget:target action:action class:self.UOClass];
}

+ (void)removeObservingTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] removeObservingTarget:target action:action object:nil];
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

- (void)addObservingTarget:(id)target block:(UOObservingBlock)block {
    [[UOEventCenter eventCenter] addObservingTarget:target block:block object:self];
}

- (void)removeObservingTarget:(id)target block:(UOObservingBlock)block {
    [[UOEventCenter eventCenter] removeObservingTarget:target block:block object:self];
}

- (void)addObservingTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] addObservingTarget:target action:action object:self];
}

- (void)removeObservingTarget:(id)target action:(SEL)action {
    [[UOEventCenter eventCenter] removeObservingTarget:target action:action object:self];
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