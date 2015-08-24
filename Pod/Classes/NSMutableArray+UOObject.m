//
//  NSMutableArray+UOObject.m
//  Pods
//
//  Created by Sungwon Lee on 8/19/15.
//
//

#import "NSMutableArray+UOObject.h"
#import "UOEventCenter.h"
#import <objc/runtime.h>

const char NSMutableArrayObjectDelegateKey;
const char NSMutableArrayObjectEventObserverKey;

@interface NSMutableArray (UOObject_Private)
- (void)__onEvent:(UOEvent *)event;
@end

@implementation NSMutableArray (UOObject)

- (void)setObjectArrayDelegate:(id<UOObjectArrayDelegate>)delegate class:(Class)klass {
    objc_setAssociatedObject(self, &NSMutableArrayObjectDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
    
    UOEventObserver *eventObserver = objc_getAssociatedObject(self, &NSMutableArrayObjectEventObserverKey);
    if (!eventObserver) {
        eventObserver = [[UOEventCenter eventCenter] addObserverWithTarget:self action:@selector(__onEvent:) class:klass];
        objc_setAssociatedObject(self, &NSMutableArrayObjectEventObserverKey, eventObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id<UOObjectArrayDelegate>)objectArrayDelegate {
    return objc_getAssociatedObject(self, &NSMutableArrayObjectDelegateKey);
}

@end

@implementation NSMutableArray (UOObject_Private)

- (void)__onEvent:(UOEvent *)event {
    id<UOObjectArrayDelegate> delegate = self.objectArrayDelegate;
    if (event.type == UOEventTypeCreate) {
        if ([self __addObjectIfNeeded:event.object]
            && [delegate respondsToSelector:@selector(objectArray:didReceiveEvent:)]) {
            [delegate objectArray:self didReceiveEvent:event];
        }
        
    } else if ([self containsObject:event.object]) {
        if (event.type == UOEventTypeDelete) {
            [self removeObject:event.object];
        }
        [delegate objectArray:self didReceiveEvent:event];
    }
}

- (BOOL)__addObjectIfNeeded:(UOObject *)object {
    id<UOObjectArrayDelegate> delegate = self.objectArrayDelegate;
    if ([delegate respondsToSelector:@selector(objectArray:shouldAddNewObject:)]
        && ![delegate objectArray:self shouldAddNewObject:object]) {
        return NO;
    }
    
    NSUInteger index = [delegate objectArray:self indexOfNewObject:object];
    if (index == NSNotFound) {
        return NO;
    }
    
    [self insertObject:object atIndex:index];
    return YES;
}

@end