//
//  UltraObjectTests.m
//  UltraObjectTests
//
//  Created by Sungwon Lee on 08/04/2015.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

// https://github.com/Specta/Specta

#import "UOTestObject.h"
#import "UOSimpleObject.h"
#import "UOObjectManager.h"
#import <UltraObject/UOObject+Protected.h>

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
        expect(UOObject.__idKey).to.equal(nil);
        expect(UOTestObject.__idKey).to.equal(@"_id");
        
        Class klass = UOTestObject.class;
        expect([klass performSelector:@selector(__idKey)]).to.equal(UOTestObject.__idKey);
    });
    
    it(@"should create objects from json array", ^{
        NSArray *testObjects = [UOTestObject objectsWithJSONArray:@[@{@"_id": @1}, @{@"_id": @2}]];
        expect(testObjects.firstObject).to.beAKindOf(UOTestObject.class);
    });
});

describe(@"UOObjectManager", ^{
    it(@"should create object manager", ^{
        expect([UOObjectManager new]).toNot.beNil();
    });
});

describe(@"UOSimpleObject", ^{
    it(@"should not have internal id", ^{
        expect([UOSimpleObject new].__id).to.beNil();
    });
});

SpecEnd