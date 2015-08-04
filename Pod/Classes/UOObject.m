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

@interface UOObject ()
@property (nonatomic, strong) NSMutableDictionary *attributes;
@end

@implementation UOObject

- (id)init {
    self = [super init];
    if (self) {
        unsigned int methodsCount = 0;
        Method* methods = (Method *)class_copyPropertyList(self.class, &methodsCount);
        for (unsigned int i = 0; i < methodsCount; ++i) {
            Method method = methods[i];
            printf("\t'%s' has method named '%s' of encoding '%s'\n",
                   class_getName(self.class),
                   sel_getName(method_getName(method)),
                   method_getTypeEncoding(method));
        }
    }
    return self;
}

- (NSMutableDictionary *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary new];
    }
    return _attributes;
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

id getValueForKey(UOObject *self, SEL _cmd) {
    NSString *key = [NSStringFromSelector(_cmd) snakeCase];
    return [self.attributes objectForKey:key];
}

void setValueForKey(UOObject *self, SEL _cmd, id value) {
    NSString *key = NSStringFromSelector(_cmd);
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(key.length - 1, 1) withString:@""];
    key = [key snakeCase];
    [self.attributes setObject:value forKey:key];
}

@end
