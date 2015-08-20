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

- (UOEventObserver *)addObservingTarget:(id)target block:(UOEventBlock)block class:(Class)klass;
- (UOEventObserver *)addObservingTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object;
- (UOEventObserver *)addObservingTarget:(id)target action:(SEL)action class:(Class)klass;
- (UOEventObserver *)addObservingTarget:(id)target action:(SEL)action object:(UOObject *)object;

- (void)removeObservingTarget:(id)target block:(UOEventBlock)block;
- (void)removeObservingTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object;
- (void)removeObservingTarget:(id)target action:(SEL)action;
- (void)removeObservingTarget:(id)target action:(SEL)action object:(UOObject *)object;

- (void)postEventForObject:(UOObject *)object type:(UOEventType)type;
- (void)postEventForObject:(UOObject *)object type:(UOEventType)type userInfo:(NSDictionary *)userInfo;

@end