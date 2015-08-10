//
//  UOComment.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import <UltraObject/UltraObject.h>

@class UOUser;
@protocol UOComment <NSObject>
@end

@interface UOComment : UOObject
@property (nonatomic, readonly) UOUser *user;
@property (nonatomic, readonly) NSString *content;
@end

@interface UOMutableComment : UOComment<UOMutableObject>
@property (nonatomic, readwrite) NSString *content;
@end