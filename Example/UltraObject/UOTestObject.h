//
//  UOTestObject.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/4/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import <UltraObject/UOObject.h>
#import <UltraObject/UOMutableObject.h>

@interface UOTestObject : UOObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *phoneNumber;
@end

@interface UOMutableTestObject : UOTestObject<UOMutableObject>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@end