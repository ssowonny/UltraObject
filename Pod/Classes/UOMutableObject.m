//
//  UOMutableObject.m
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import "UOObject.h"
#import "UOObject+Protected.h"
#import "UOMutableObject.h"
#import "UOObjectManager.h"

@implementation UOObject (UOMutableObject)

- (instancetype)synchronize {
    NSAssert(self.__id, @"`__id` should not be nil.");
    UOObject *object = [[UOObjectManager sharedManager] objectWithClass:self.UOClass forID:self.__id];
    return [self synchronizeWithObject:object];
}

- (instancetype)synchronizeWithObject:(UOObject *)object {
    if (self.__id && ![(NSObject*)self.__id isEqual:object.__id]) {
        [[UOObjectManager sharedManager] setObject:object forID:self.__id];
    }
    
    [object importDictionary:self.toDictionary];
    [object postEventWithType:UOEventTypeUpdate];
    return object;
}

@end