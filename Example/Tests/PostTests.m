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

SpecBegin(UOPost)

describe(@"UOPost", ^{
    __block UOPost *post = nil;
    
    beforeAll(^{
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
    });
});

SpecEnd