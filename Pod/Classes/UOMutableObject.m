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

- (void)synchronize {
    UOObject *object = [[UOObjectManager sharedManager] objectWithClass:self.UOClass forID:self.id];
    [object importDictionary:self.toDictionary];
    [[UOEventCenter eventCenter] postEventForObject:object];
}

@end