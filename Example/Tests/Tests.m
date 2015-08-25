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
    it(@"should create mutable object", ^{
        expect([[UOTestObject objectWithID:@1] mutableCopy]).to.beInstanceOf(UOMutableTestObject.class);
    });
    
    it(@"should share memory only for same identifier", ^{
        UOTestObject *testObject = [UOTestObject objectWithID:@1];
        UOTestObject *sameObject = [UOTestObject objectWithID:@1];
        UOTestObject *otherObject = [UOTestObject objectWithID:@2];
        expect(testObject).to.equal(sameObject);
        expect(testObject).toNot.equal(otherObject);
    });
    
    it(@"should return overriden id key", ^{
        expect(UOObject.idKey).to.equal(@"id");
        expect(UOTestObject.idKey).to.equal(@"_id");
        
        Class klass = UOTestObject.class;
        expect([klass performSelector:@selector(idKey)]).to.equal(UOTestObject.idKey);
    });
});

describe(@"UOObjectManager", ^{
    it(@"should create object manager", ^{
        expect([UOObjectManager new]).toNot.beNil;
    });
});

SpecEnd