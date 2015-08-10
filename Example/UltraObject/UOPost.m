//
//  UOPost.m
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOPost.h"

@interface UOPost ()
@property (nonatomic, strong) UOUser *user;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray<UOComment> *comments;
@end

@implementation UOPost
@end

@implementation UOMutablePost
@synthesize content;
@end