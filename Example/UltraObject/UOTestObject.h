//
//  UOTestObject.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/4/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import <UltraObject/UOObject.h>
#import <UltraObject/UOMutableObject.h>

@protocol UOTestObject <NSObject>
@end

@interface UOTestObject : UOObject
@property (nonatomic, readonly) NSNumber *_id;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) NSArray<UOTestObject> *testObjects;
@end

@interface UOMutableTestObject : UOTestObject<UOMutableObject>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@end