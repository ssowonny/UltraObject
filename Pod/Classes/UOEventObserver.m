//
//  UOEventObserver.m
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import "UOEventObserver.h"
#import "UOEventCenter.h"
#import "UOObject+Protected.h"

@implementation UOEventObserver

- (instancetype)initWithTarget:(id)target class:(Class)klass {
    self = [super init];
    if (self) {
        _target = target;
        _klass = klass;
    }
    return self;
}


- (void)dealloc {
    // It's not necessary to remove the observer from the target,
    // since the observer is associated with the target.
    [[UOEventCenter eventCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)notification {
}

- (NSString *)key {
    NSAssert(NO, @"`key` should be overriden.");
    return nil;
}

@end

