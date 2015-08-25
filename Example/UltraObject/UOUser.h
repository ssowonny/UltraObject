//
//  UOUser.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/6/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOBaseObject.h"

@interface UOUser : UOBaseObject
@property (nonatomic, readonly) NSString *name;
@end

@interface UOMutableUser : UOUser<UOMutableObject>
@property (nonatomic, readwrite) NSString *name;
@end
