//
//  UOPost.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOBaseObject.h"

@class UOUser;
@protocol UOComment;

@interface UOPost : UOBaseObject
@property (nonatomic, readonly) UOUser *user;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSArray<UOComment> *comments;
@end

@interface UOMutablePost : UOPost<UOMutableObject>
@property (nonatomic, readwrite) NSString *content;
@end
