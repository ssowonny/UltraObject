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
        [post addObservingTarget:self block:^(UOObject *object) {
            observingBlockPerformed = YES;
        }];
        
        [[UOEventCenter eventCenter] postEventForObject:post];
        expect(observingBlockPerformed).to.beTruthy;
    });
    
    it(@"should remove deallocated observing blocks", ^{
        UOPost *post = [UOPost objectWithID:@1];
        NSObject *observer = [NSObject new];
        
        __block BOOL observingBlockPerformed = NO;
        [post addObservingTarget:self block:^(UOObject *object) {
            observingBlockPerformed = YES;
        }];
        
        observer = nil;
        [[UOEventCenter eventCenter] postEventForObject:post];
        expect(observingBlockPerformed).to.beFalsy;
    });
    
    it(@"should not perform other object's observing block", ^{
        UOPost *post = [UOPost objectWithID:@1];
        UOPost *otherPost = [UOPost objectWithID:@2];
        
        __block BOOL observingBlockPerformed = NO;
        [post addObservingTarget:self block:^(UOObject *object) {
            observingBlockPerformed = YES;
        }];
        
        [[UOEventCenter eventCenter] postEventForObject:otherPost];
        expect(observingBlockPerformed).to.beFalsy;
    });
    
    it(@"should reuse observing blocks", ^{
        __block int callCount = 0;
        UOObservingBlock observingBlock = ^(UOObject *object) {
            ++ callCount;
        };
        
        UOPost *post = [UOPost objectWithID:@1];
        UOPost *otherPost = [UOPost objectWithID:@2];
        [post addObservingTarget:self block:observingBlock];
        [otherPost addObservingTarget:self block:observingBlock];
        
        [[UOEventCenter eventCenter] postEventForObject:post];
        [[UOEventCenter eventCenter] postEventForObject:otherPost];
        expect(callCount).to.equal(2);
    });
    
    it(@"should remove proper observing block", ^{
        __block int callCount = 0;
        UOObservingBlock observingBlock = ^(UOObject *object) {
            ++ callCount;
        };
        
        UOPost *post = [UOPost objectWithID:@1];
        UOPost *otherPost = [UOPost objectWithID:@2];
        [post addObservingTarget:self block:observingBlock];
        [otherPost addObservingTarget:self block:observingBlock];
        [post removeObservingTarget:self block:observingBlock];
        
        [[UOEventCenter eventCenter] postEventForObject:post];
        [[UOEventCenter eventCenter] postEventForObject:otherPost];
        expect(callCount).to.equal(1);
    });
    
    context(@"when observing class events", ^{
        __block int classEventCallCount;
        __block id target;
        
        beforeEach(^{
            classEventCallCount = 0;
            target = [NSObject new];
            
            [UOPost addObservingTarget:target block:^(UOObject *object){
                ++ classEventCallCount;
            }];
        });
        
        it(@"should call class event observing block", ^{
            UOPost *post = [UOPost objectWithID:@1];
            [[UOEventCenter eventCenter] postEventForObject:post];
            expect(classEventCallCount).to.equal(1);
        });
        
        it(@"should remove deallocated observing blocks", ^{
            target = nil;
            UOPost *post = [UOPost objectWithID:@1];
            [[UOEventCenter eventCenter] postEventForObject:post];
            expect(classEventCallCount).to.equal(0);
        });
    });
});

SpecEnd