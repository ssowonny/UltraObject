//
//  UOEventCenter.h
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import <Foundation/Foundation.h>

@class UOObject;
typedef void (^UOObservingBlock)(UOObject *);

@interface UOEventCenter : NSNotificationCenter

+ (UOEventCenter *)eventCenter;

- (void)addObservingBlock:(UOObservingBlock)observingBlock forClass:(Class)klass withTarget:(id)target;
- (void)addObservingBlock:(UOObservingBlock)observingBlock forObject:(UOObject *)object withTarget:(id)target;

- (void)removeObservingBlock:(UOObservingBlock)observingBlock forClass:(Class)klass withTarget:(id)target;
- (void)removeObservingBlock:(UOObservingBlock)observingBlock forObject:(UOObject *)object withTarget:(id)target;

- (void)postEventForObject:(UOObject *)object;

@end
