//
//  UOObjectActionObserver.h
//  Pods
//
//  Created by Sungwon Lee on 8/19/15.
//
//

#import "UOEventObserver.h"

@interface UOObjectActionObserver : UOEventObserver

@property (nonatomic, weak, readonly) UOObject *object;
@property (nonatomic, assign, readonly) SEL action;

+ (NSString *)keyForAction:(SEL)action object:(UOObject *)object;

- (instancetype)initWithTarget:(id)target action:(SEL)action object:(UOObject *)object;
- (instancetype)initWithTarget:(id)target action:(SEL)action class:(Class)klass;

@end
