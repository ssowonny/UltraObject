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

@interface UOObject () {
    Class _mutableClass;
}

@property (nonatomic, strong) NSMutableDictionary *objectAttributes;
@end

@implementation UOObject

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self loadJSON:dictionary];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    UOObject *object = [[self.class allocWithZone:zone] init];
    object.objectAttributes = [self.objectAttributes copy];
    return object;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    Class mutableClass = [[UOObjectManager sharedManager] mutableClassWithClass:self.class];
    UOObject *mutableObject = [[mutableClass allocWithZone:zone] init];
    mutableObject.objectAttributes = [self.objectAttributes mutableCopy];
    return mutableObject;
}

- (NSMutableDictionary *)objectAttributes {
    if (!_objectAttributes) {
        _objectAttributes = [NSMutableDictionary new];
    }
    return _objectAttributes;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString hasPrefix:@"set"]) {
        return class_addMethod([self class], sel, (IMP) setValueForKey, "v@:@");
    } else {
        return class_addMethod([self class], sel, (IMP) getValueForKey, "@@:");
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark - Private methods

id getValueForKey(UOObject *self, SEL _cmd) {
    NSString *key = [NSStringFromSelector(_cmd) snakeCase];
    return [self.objectAttributes objectForKey:key];
}

void setValueForKey(UOObject *self, SEL _cmd, id value) {
    NSString *key = NSStringFromSelector(_cmd);
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(key.length - 1, 1) withString:@""];
    key = [key snakeCase];
    [self.objectAttributes setObject:value forKey:key];
}

- (void)loadJSON:(NSDictionary *)json {
    [self.objectAttributes removeAllObjects];
    
    for (NSString *key in json) {
        Method method = class_getInstanceMethod(self.class, NSSelectorFromString(key));
        char *cReturnType = method_copyReturnType(method);
        NSString *returnType = [NSString stringWithFormat:@"%s", cReturnType];
        Class class = NSClassFromString(returnType);
        // TODO Handle array, dictionary, set, etc.
        if ([class isSubclassOfClass:UOObject.class]) {
            // TODO Initialize class using object manager.
            self.objectAttributes[key] = [(UOObject*)class initWithDictionary:json[key]];
        } else {
            self.objectAttributes[key] = json[key];
        }
    }
}

- (NSDictionary *)toJSON {
    NSMutableDictionary *json = [NSMutableDictionary new];
    for (NSString *key in self.objectAttributes) {
        Method method = class_getInstanceMethod(self.class, NSSelectorFromString(key));
        char *cReturnType = method_copyReturnType(method);
        NSString *returnType = [NSString stringWithFormat:@"%s", cReturnType];
        Class class = NSClassFromString(returnType);
        // TODO Handle array, dictionary, set, etc.
        if ([class isSubclassOfClass:UOObject.class]) {
            json[key] = [(UOObject *)self.objectAttributes[key] toJSON];
        } else {
            json[key] = self.objectAttributes[key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:json];
}

@end
