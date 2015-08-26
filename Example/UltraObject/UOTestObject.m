//
//  UOTestObject.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/4/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOTestObject.h"

@interface UOTestObject ()
@property (nonatomic, strong) NSNumber<UOIdentifier> *_id;
@end

@implementation UOTestObject
@end

@implementation UOMutableTestObject
@synthesize name, phoneNumber;
@end