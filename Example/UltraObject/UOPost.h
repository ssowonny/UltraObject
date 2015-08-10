//
//  UOPost.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import <UltraObject/UltraObject.h>

@class UOUser;
@protocol UOComment;

@interface UOPost : UOObject
@property (nonatomic, readonly) UOUser *user;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, readonly) NSArray<UOComment> *comments;
@end

@interface UOMutablePost : UOPost<UOMutableObject>
@property (nonatomic, readwrite) NSString *content;
@end
