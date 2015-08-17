//
//  UOEventObserver.m
//  Pods
//
//  Created by Sungwon Lee on 8/17/15.
//
//

#import "UOEventObserver.h"

@implementation UOEventObserver

+ (NSString *)keyForObservingBlock:(UOObservingBlock)observingBlock withObject:(UOObject *)object {
    return [NSString stringWithFormat:@"UOEventObserver#%p#%p", observingBlock, object];
}

- (void)dealloc {
    [[UOEventCenter eventCenter] removeObserver:self];
}

- (void)onEvent:(NSNotification *)event {
    if (_observingBlock && (!self.object || [event.object isEqual:self.object])) {
        _observingBlock(event.object);
    }
}

- (NSString *)key {
    return [self.class keyForObservingBlock:_observingBlock withObject:_object];
}

@end

