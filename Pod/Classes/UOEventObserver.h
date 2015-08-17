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
@property (nonatomic, strong) UOObservingBlock observingBlock;
@property (nonatomic, weak) UOObject *object;

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock withObject:(UOObject *)object;
- (void)onEvent:(NSNotification *)event;

@end

