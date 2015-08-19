//
//  UOObjectBlockObserver.h
//  Pods
//
//  Created by Sungwon Lee on 8/19/15.
//
//

#import "UOEventObserver.h"

@class UOEvent;
typedef void (^UOObservingBlock)(UOEvent *);

@interface UOObjectBlockObserver : UOEventObserver

@property (nonatomic, weak, readonly) UOObject *object;
@property (nonatomic, strong, readonly) UOObservingBlock observingBlock;

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock object:(UOObject *)object;

- (instancetype)initWithTarget:(id)target block:(UOObservingBlock)block object:(UOObject *)object;
- (instancetype)initWithTarget:(id)target block:(UOObservingBlock)block class:(Class)klass;

@end
