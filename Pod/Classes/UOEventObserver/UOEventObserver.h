//
//  UOEventObserver.h
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

@class UOObject;

@interface UOEventObserver : NSObject

@property (nonatomic, readonly) NSString *key;
@property (nonatomic, weak, readonly) id target;
@property (nonatomic, weak, readonly) Class klass;

- (instancetype)initWithTarget:(id)target class:(Class)klass;
- (void)onEvent:(NSNotification *)notification;

@end