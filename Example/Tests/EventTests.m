//
//  EventTests.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/17/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOPost.h"
#import "UOUser.h"
#import "UOComment.h"
#import "UOEventCenter.h"

SpecBegin(UOEventCenter)

describe(@"UOEventCenter", ^{
    it(@"should perform observing block", ^{
        UOPost *post = [UOPost objectWithID:@1];
        __block BOOL observingBlockPerformed = NO;
        [post addObservingBlock:^(UOObject *object) {
            observingBlockPerformed = YES;
        } withTarget:self];
        
        [[UOEventCenter eventCenter] postEventForObject:post];
        expect(observingBlockPerformed).to.beTruthy;
    });
    
    it(@"should remove deallocated observing blocks", ^{
        UOPost *post = [UOPost objectWithID:@1];
        NSObject *observer = [NSObject new];
        
        __block BOOL observingBlockPerformed = NO;
        [post addObservingBlock:^(UOObject *object) {
            observingBlockPerformed = YES;
        } withTarget:observer];
        
        observer = nil;
        [[UOEventCenter eventCenter] postEventForObject:post];
        expect(observingBlockPerformed).to.beFalsy;
    });
});

SpecEnd