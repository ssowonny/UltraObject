//
//  UOEventCenter.h
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import "UOEvent.h"
#import "UOBlockDefinitions.h"

@class UOObject, UOEventObserver;

@interface UOEventCenter : NSNotificationCenter

+ (UOEventCenter *)eventCenter;

- (UOEventObserver *)addObserverWithTarget:(id)target block:(UOEventBlock)block class:(Class)klass;
- (UOEventObserver *)addObserverWithTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object;
- (UOEventObserver *)addObserverWithTarget:(id)target action:(SEL)action class:(Class)klass;
- (UOEventObserver *)addObserverWithTarget:(id)target action:(SEL)action object:(UOObject *)object;

- (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block;
- (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object;
- (void)removeObserverWithTarget:(id)target action:(SEL)action;
- (void)removeObserverWithTarget:(id)target action:(SEL)action object:(UOObject *)object;

- (void)postEventForObject:(UOObject *)object type:(UOEventType)type;
- (void)postEventForObject:(UOObject *)object type:(UOEventType)type userInfo:(NSDictionary *)userInfo;

@end