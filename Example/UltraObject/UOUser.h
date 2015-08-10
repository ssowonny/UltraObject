//
//  UOUser.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import <UltraObject/UltraObject.h>

@interface UOUser : UOObject
@property (nonatomic, readonly) NSString *name;
@end

@interface UOMutableUser : UOUser<UOMutableObject>
@property (nonatomic, readwrite) NSString *name;
@end
