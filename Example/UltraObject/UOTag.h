//
//  UOTag.h
//  UltraObject
//
//  Created by Sungwon Lee on 8/26/15.
//  Copyright (c) 2015 Sungwon Lee. All rights reserved.
//

#import "UOBaseObject.h"

@interface UOTag : UOBaseObject
@property (nonatomic, readonly) NSString<UOIdentifier> *name;
@end
