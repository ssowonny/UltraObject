//
//  PostTests.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOPost.h"
#import "UOUser.h"
#import "UOComment.h"

@interface UOPostArrayDelegate : NSObject<UOObjectArrayDelegate>
@property (nonatomic, assign) BOOL shouldIgnoreNewObject;
@property (nonatomic, readonly) NSUInteger eventCallCount;
@end

@implementation UOPostArrayDelegate

- (NSUInteger)objectArray:(NSMutableArray *)array indexOfNewObject:(UOObject *)object {
    return 0;
}

- (void)objectArray:(NSMutableArray *)array didReceiveEvent:(UOEvent *)event {
    ++_eventCallCount;
}

- (BOOL)objectArray:(NSMutableArray *)array shouldAddNewObject:(UOObject *)object {
    return !_shouldIgnoreNewObject;
}

@end

SpecBegin(UOPost)

describe(@"UOPost", ^{
    __block UOPost *post = nil;
    
    beforeEach(^{
        NSDictionary *postJSON = @{
                                   @"id": @1,
                                   @"content": @"Hello World",
                                   @"user": @{@"id": @1, @"name": @"John Doe" },
                                   @"comments": @[@{
                                                      @"id": @1,
                                                      @"content": @"Hi There",
                                                      @"user": @{@"id": @2, @"name": @"Jane Roe"}
                                                      }]
                                   };
        post = [UOPost objectWithJSON:postJSON];
    });
    
    it(@"should parse json", ^{
        expect(post.user.name).to.equal(@"John Doe");
        expect(post.comments.count).to.equal(1);
        
        UOComment *comment = post.comments.firstObject;
        expect(comment.content).to.equal(@"Hi There");
    });
    
    it(@"should create mutable post", ^{
        UOMutablePost *mutablePost = [post mutableCopy];
        expect(mutablePost.content).to.equal(post.content);
        expect(mutablePost.user).to.equal(post.user);
    });
    
    it(@"should edit content", ^{
        NSString *newContent = @"Ola qua tal";
        [post edit:^(UOMutablePost *mutablePost) {
            mutablePost.content = newContent;
        }];
        expect(post.content).to.equal(newContent);
    });
    
    it(@"should create new post", ^{
        NSDictionary *postJSON = @{@"id": @1, @"content": @"Hi There"};
        UOPost *newPost = [UOPost newWithJSON:postJSON];
        expect(newPost.content).to.equal(postJSON[@"content"]);
    });
});

describe(@"UOPost array", ^{
    __block NSMutableArray *posts = nil;
    __block UOPostArrayDelegate *delegate = nil;
    
    beforeEach(^{
        NSString *dummyData = @"{\"posts\":[{\"id\":1,\"content\":\"Hello World\",\"user\":{\"id\":1,\"name\":\"John Doe\"},\"comments\":[]},{\"id\":2,\"content\":\"Hi There\",\"user\":{\"id\":1,\"name\":\"John Doe\"},\"comments\":[]},{\"id\":3,\"content\":\"Party Time\",\"user\":{\"id\":2,\"name\":\"Jane Roe\"},\"comments\":[]},{\"id\":4,\"content\":\"Summer Night\",\"user\":{\"id\":2,\"name\":\"Jane Roe\"},\"comments\":[]}]}";
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[dummyData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        posts = [UOPost arrayOfModelsFromDictionaries:json[@"posts"]];
        delegate = [UOPostArrayDelegate new];
        [posts setObjectArrayDelegate:delegate class:UOPost.class];
    });
    
    it(@"should call update event", ^{
        UOObject *post = posts.lastObject;
        [post edit:^(UOMutablePost *mutablePost) {
            mutablePost.content = @"New Content";
        }];
        expect(delegate.eventCallCount).to.equal(1);
    });
    
    it(@"should delete an object", ^{
        NSUInteger postsCount = posts.count;
        UOObject *post = posts.lastObject;
        [post destroy];
        expect(posts.count).to.equal(postsCount - 1);
    });
    
    context(@"when an object is created", ^{
        __block NSDictionary *postJSON = @{@"id": @100, @"content": @"New Post"};
        
        it(@"should add an object", ^{
            NSUInteger postsCount = posts.count;
            [UOPost newWithJSON:postJSON];
            expect(posts.count).to.equal(postsCount + 1);
            expect(((UOPost *)posts.firstObject).content).to.equal(postJSON[@"content"]);
        });
        
        it(@"should not add an object", ^{
            NSUInteger postsCount = posts.count;
            delegate.shouldIgnoreNewObject = YES;
            [UOPost newWithJSON:postJSON];
            expect(posts.count).to.equal(postsCount);
        });
    });

});

SpecEnd
