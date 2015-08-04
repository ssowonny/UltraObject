//
//  UltraObjectTests.m
//  UltraObjectTests
//
//  Created by Sungwon Lee on 08/04/2015.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

// https://github.com/Specta/Specta

#import "UOTestObject.h"

SpecBegin(InitialSpecs)

describe(@"Initializing UOTestObject", ^{
    it(@"should create test object", ^{
        expect([UOTestObject new]).toNot.beNil;
    });
    
    it(@"have dynamic property", ^{
        expect([UOTestObject new].name).to.beNil;
    });
});

describe(@"Initializing UOMutableTestObject", ^{
    it(@"should create mutable object", ^{
        expect([UOMutableTestObject new]).toNot.beNil;
    });
    
    it(@"can set attributes", ^{
        UOMutableTestObject *mutableObject = [UOMutableTestObject new];
        expect(mutableObject.phoneNumber).to.beNil;
        NSString *phoneNumber = @"+001012345678";
        mutableObject.phoneNumber = phoneNumber;
        expect(mutableObject.phoneNumber).to.equal(phoneNumber);
    });
});

SpecEnd

