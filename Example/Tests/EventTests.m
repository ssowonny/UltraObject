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

@interface UOTargetWithAction : NSObject
@property (nonatomic, assign) int callCount;
- (void)onEvent:(UOObject *)object;
@end

@implementation UOTargetWithAction
- (void)onEvent:(UOObject *)object {
    ++ _callCount;
}
@end

SpecBegin(UOEventCenter)

describe(@"UOEventCenter", ^{
    __block id target;
    beforeEach(^{
        target = [NSObject new];
    });
    
    it(@"should perform observing block", ^{
        UOPost *post = [UOPost objectWithID:@1];
        __block BOOL eventBlockPerformed = NO;
        __weak UOPost *weakPost = post;
        [post addObserverWithTarget:target block:^(UOEvent *event) {
            eventBlockPerformed = YES;
            expect(event.type).to.equal(UOEventTypeUpdate);
            expect(event.object).to.equal(weakPost);
        }];
        
        [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
        expect(eventBlockPerformed).to.beTruthy();
    });
    
    it(@"should receive proper event type", ^{
        __block UOEventType expectedEventType;
        [UOPost addObserverWithTarget:target block:^(UOEvent *event) {
            expect(event.type).to.equal(expectedEventType);
        }];
        
        expectedEventType = UOEventTypeCreate;
        UOPost *post = [UOPost newWithJSON:@{@"id": @1}];
        
        expectedEventType = UOEventTypeUpdate;
        [post edit:^(UOMutablePost *mutablePost) {
            mutablePost.content = @"new content";
        }];
        
        expectedEventType = UOEventTypeDelete;
        [post destroy];
    });
    
    it(@"should remove deallocated observing blocks", ^{
        UOPost *post = [UOPost objectWithID:@1];
        __block BOOL eventBlockPerformed = NO;
        [post addObserverWithTarget:target block:^(UOEvent *event) {
            eventBlockPerformed = YES;
        }];
        
        target = nil;
        [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
        expect(eventBlockPerformed).to.beFalsy();
    });
    
    it(@"should not perform other object's observing block", ^{
        UOPost *post = [UOPost objectWithID:@1];
        UOPost *otherPost = [UOPost objectWithID:@2];
        
        __block BOOL eventBlockPerformed = NO;
        [post addObserverWithTarget:target block:^(UOEvent *event) {
            eventBlockPerformed = YES;
        }];
        
        [[UOEventCenter eventCenter] postEventForObject:otherPost type:UOEventTypeUpdate];
        expect(eventBlockPerformed).to.beFalsy();
    });
    
    it(@"should reuse observing blocks", ^{
        __block int callCount = 0;
        UOEventBlock eventBlock = ^(UOEvent *event) {
            ++ callCount;
        };
        
        UOPost *post = [UOPost objectWithID:@1];
        UOPost *otherPost = [UOPost objectWithID:@2];
        [post addObserverWithTarget:target block:eventBlock];
        [otherPost addObserverWithTarget:target block:eventBlock];
        
        [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
        [[UOEventCenter eventCenter] postEventForObject:otherPost type:UOEventTypeUpdate];
        expect(callCount).to.equal(2);
    });
    
    it(@"should remove proper observing block", ^{
        __block int callCount = 0;
        UOEventBlock eventBlock = ^(UOEvent *event) {
            ++ callCount;
        };
        
        UOPost *post = [UOPost objectWithID:@1];
        UOPost *otherPost = [UOPost objectWithID:@2];
        [post addObserverWithTarget:target block:eventBlock];
        [otherPost addObserverWithTarget:target block:eventBlock];
        [post removeObserverWithTarget:target block:eventBlock];
        
        [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
        [[UOEventCenter eventCenter] postEventForObject:otherPost type:UOEventTypeUpdate];
        expect(callCount).to.equal(1);
    });
    
    context(@"when editing post", ^{
        it(@"should perform observing block", ^{
            UOPost *post = [UOPost objectWithID:@1];
            __block BOOL eventBlockPerformed = NO;
            [post addObserverWithTarget:target block:^(UOEvent *event) {
                eventBlockPerformed = YES;
            }];
            
            [post edit:^(UOMutablePost *mutablePost) {
                mutablePost.content = @"New content";
            }];
            expect(eventBlockPerformed).to.beTruthy();
        });
    });
    
    describe(@"with class event observers", ^{
        __block int classEventCallCount;
        
        beforeEach(^{
            classEventCallCount = 0;
            
            [UOPost addObserverWithTarget:target block:^(UOEvent *event) {
                ++ classEventCallCount;
            }];
        });
        
        it(@"should call class event observing block", ^{
            UOPost *post = [UOPost objectWithID:@1];
            [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
            expect(classEventCallCount).to.equal(1);
        });
        
        it(@"should remove deallocated observing blocks", ^{
            target = nil;
            UOPost *post = [UOPost objectWithID:@1];
            [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
            expect(classEventCallCount).to.equal(0);
        });
    });
    
    describe(@"with action selector", ^{
        it(@"should call action selector", ^{
            UOPost *post = [UOPost objectWithID:@1];
            UOTargetWithAction *target = [UOTargetWithAction new];
            [post addObserverTarget:target action:@selector(onEvent:)];
            
            [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
            expect(target.callCount).to.equal(1);
        });
        
        it(@"should call action selector for class events", ^{
            UOTargetWithAction *target = [UOTargetWithAction new];
            [UOPost addObserverWithTarget:target action:@selector(onEvent:)];
            
            UOPost *post = [UOPost objectWithID:@1];
            [[UOEventCenter eventCenter] postEventForObject:post type:UOEventTypeUpdate];
            expect(target.callCount).to.equal(1);
        });
    });
});

SpecEnd