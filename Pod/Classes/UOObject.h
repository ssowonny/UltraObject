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

+ (void)addObservingTarget:(id)target block:(UOObservingBlock)block;
+ (void)removeObservingTarget:(id)target block:(UOObservingBlock)block;

- (void)addObservingTarget:(id)target block:(UOObservingBlock)block;
- (void)removeObservingTarget:(id)target block:(UOObservingBlock)block;

@end