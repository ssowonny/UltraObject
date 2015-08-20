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

#ifndef UOObjectIDKey
#define UOObjectIDKey @"id"
#endif

#ifndef UOObjectIDType
#define UOObjectIDType id<NSCoding, NSCopying>
#endif

@protocol UOMutableObject;
typedef UOObjectIDType UOID;
typedef void (^UOEditBlock)(id<UOMutableObject>);

@interface UOObject : JSONModel<NSCopying, NSMutableCopying>
@property (nonatomic, readonly) UOID id;

+ (instancetype)objectWithID:(UOID)ID;
+ (instancetype)objectWithJSON:(NSDictionary *)json;
+ (instancetype)new:(NSDictionary *)json;

+ (void)addObservingTarget:(id)target block:(UOEventBlock)block;
+ (void)removeObservingTarget:(id)target block:(UOEventBlock)block;

+ (void)addObservingTarget:(id)target action:(SEL)action;
+ (void)removeObservingTarget:(id)target action:(SEL)action;

- (void)addObservingTarget:(id)target block:(UOEventBlock)block;
- (void)removeObservingTarget:(id)target block:(UOEventBlock)block;

- (void)addObservingTarget:(id)target action:(SEL)action;
- (void)removeObservingTarget:(id)target action:(SEL)action;

- (void)postEventWithType:(UOEventType)type;
- (void)postEventWithType:(UOEventType)type userInfo:(NSDictionary *)userInfo;

- (void)edit:(UOEditBlock)block;
- (void)destroy;

@end