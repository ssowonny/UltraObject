//
//  UOObject.h
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "UOEventCenter.h"

#define UOObjectIDKey @"id"

typedef id<NSCoding, NSCopying> UOID;

@interface UOObject : JSONModel<NSCopying, NSMutableCopying>
@property (nonatomic, readonly) UOID id;

+ (instancetype)objectWithID:(UOID)ID;
+ (instancetype)objectWithJSON:(NSDictionary *)json;

- (void)addObservingBlock:(UOObservingBlock)observingBlock withTarget:(id)target;
- (void)removeObservingBlock:(UOObservingBlock)observingBlock withTarget:(id)target;

@end