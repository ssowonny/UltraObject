//
//  UOMutableObject.h
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import "UOObject.h"

@protocol UOMutableObject <NSObject>
@optional
- (instancetype)synchronize;
- (instancetype)synchronizeWithObject:(UOObject *)object;
@end