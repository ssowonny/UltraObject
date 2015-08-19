//
//  UOObjectBlockObserver.h
//  Pods
//
//  Created by Sungwon Lee on 8/19/15.
//
//

#import "UOEventObserver.h"
#import "UOBlockDefinitions.h"

@class UOEvent;

@interface UOObjectBlockObserver : UOEventObserver

@property (nonatomic, weak, readonly) UOObject *object;
@property (nonatomic, strong, readonly) UOEventBlock eventBlock;

+ (NSString *)keyForEventBlock:(UOEventBlock)eventBlock object:(UOObject *)object;

- (instancetype)initWithTarget:(id)target block:(UOEventBlock)block object:(UOObject *)object;
- (instancetype)initWithTarget:(id)target block:(UOEventBlock)block class:(Class)klass;

@end
