//
//  UltraObjectTests.m
//  UltraObjectTests
//
//  Created by Sungwon Lee on 08/04/2015.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

// https://github.com/Specta/Specta

#import "UOTestObject.h"
#import "UOObjectManager.h"

SpecBegin(InitialSpecs)

describe(@"UOTestObject", ^{
    it(@"should create test object", ^{
        expect([UOTestObject new]).toNot.beNil;
    });
    
    it(@"have dynamic property", ^{
        expect([UOTestObject new].name).to.beNil;
    });
    
    it(@"should create mutable object", ^{
        expect([[UOTestObject new] mutableCopy]).to.beInstanceOf(UOMutableTestObject.class);
    });
    
    it(@"should share memory only for same identifier", ^{
        UOTestObject *testObject = [UOTestObject objectWithID:@1];
        UOTestObject *sameObject = [UOTestObject objectWithID:@1];
        UOTestObject *otherObject = [UOTestObject objectWithID:@2];
        expect(testObject).to.equal(sameObject);
        expect(testObject).toNot.equal(otherObject);
    });
});

describe(@"UOMutableTestObject", ^{
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

describe(@"UOObjectManager", ^{
    it(@"should create object manager", ^{
        expect([UOObjectManager new]).toNot.beNil;
    });
});

SpecEnd