//
//  UOEventCenter.h
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import <Foundation/Foundation.h>

@class UOObject, UOEventObserver;
typedef void (^UOObservingBlock)(UOObject *);

@interface UOEventCenter : NSNotificationCenter

+ (UOEventCenter *)eventCenter;

- (void)addObservingTarget:(id)target block:(UOObservingBlock)observingBlock class:(Class)klass;
- (void)addObservingTarget:(id)target block:(UOObservingBlock)observingBlock object:(UOObject *)object;

- (void)removeObservingTarget:(id)target block:(UOObservingBlock)observingBlock;
- (void)removeObservingTarget:(id)target block:(UOObservingBlock)observingBlock object:(UOObject *)object;

- (void)postEventForObject:(UOObject *)object;

@end
