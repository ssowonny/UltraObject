//
//  UOObject.m
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import <objc/runtime.h>
#import "UOObject.h"
#import "NSString+Conversion.h"
#import "UOObjectManager.h"
#import "UOMutableObject.h"
#import "UOObject+Protected.h"

@interface UOObject () {
    Class _mutableClass;
}
@property (nonatomic, strong) UOID id;
@end

@implementation UOObject
@synthesize id;

+ (instancetype)objectWithJSON:(NSDictionary *)json {
    return [[UOObjectManager sharedManager] objectWithClass:self.class forJSON:json];
}

+ (instancetype)objectWithID:(UOID)ID {
    return [[UOObjectManager sharedManager] objectWithClass:self.class forID:ID];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    UOObject *object = [[self.class allocWithZone:zone] init];
    object.id = self.id;
    return object;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    Class mutableClass = [[UOObjectManager sharedManager] mutableClassWithClass:self.class];
    UOObject *mutableObject = [[mutableClass allocWithZone:zone] init];
    mutableObject.id = self.id;
    return mutableObject;
}

#pragma mark - Private methods

@end


@implementation UOObject (Protected)

- (instancetype)initWithID:(UOID)ID {
    self = [super init];
    if (self) {
        self.id = ID;
    }
    return self;
}

@end