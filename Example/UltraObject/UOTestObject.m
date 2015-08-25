//
//  UOTestObject.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/4/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOTestObject.h"

@interface UOTestObject ()
@property (nonatomic, strong) NSNumber *_id;
@end

@implementation UOTestObject

+ (NSString *)idKey {
    return @"_id";
}

@end

@implementation UOMutableTestObject
@synthesize name, phoneNumber;
@end