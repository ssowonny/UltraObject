//
//  TagTests.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/26/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOTag.h"
#import <UltraObject/UOObject+Protected.h>

SpecBegin(UOTag)

describe(@"UOTag", ^{
    it(@"should use name as id json", ^{
        UOTag *tag = [UOTag objectWithJSON:@{@"id": @1, @"name": @"sky"}];
        expect(tag.__id).to.equal(@"sky");
    });
});

SpecEnd