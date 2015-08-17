//
//  UOEventObserver.h
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import "UOEventCenter.h"

@class UOObject;

@interface UOEventObserver : NSObject

@property (nonatomic, readonly) NSString *key;
@property (nonatomic, strong, readonly) UOObservingBlock observingBlock;
@property (nonatomic, weak, readonly) UOObject *object;
@property (nonatomic, weak, readonly) id target;
@property (nonatomic, weak, readonly) Class klass;

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock withObject:(UOObject *)object;

- (instancetype)initWithTarget:(id)target observingBlock:(UOObservingBlock)observingBlock object:(UOObject *)object;
- (instancetype)initWithTarget:(id)target observingBlock:(UOObservingBlock)observingBlock class:(Class)klass;

- (void)onEvent:(NSNotification *)event;

@end