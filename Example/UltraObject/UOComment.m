//
//  UOComment.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOComment.h"

@interface UOComment ()
@property (nonatomic, strong) UOUser *user;
@property (nonatomic, strong) NSString *content;
@end

@implementation UOComment
@end

@implementation UOMutableComment
@synthesize content;
@end