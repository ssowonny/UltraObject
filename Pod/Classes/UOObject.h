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

#ifndef UOObjectIDType
#define UOObjectIDType id<NSCoding, NSCopying, Optional>
#endif

@protocol UOMutableObject, UOIdentifier, UONoIdentifier;
typedef UOObjectIDType UOID;
typedef void (^UOEditBlock)(id<UOMutableObject>);

@interface UOObject : JSONModel<NSCopying, NSMutableCopying>

+ (instancetype)objectWithID:(UOID)ID;
+ (instancetype)objectWithJSON:(NSDictionary *)json;
+ (NSArray *)objectsWithJSONArray:(NSArray *)jsonArray;
+ (instancetype)new:(NSDictionary *)json;

+ (void)addObserverWithTarget:(id)target block:(UOEventBlock)block;
+ (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block;

+ (void)addObserverWithTarget:(id)target action:(SEL)action;
+ (void)removeObserverWithTarget:(id)target action:(SEL)action;

- (void)addObserverWithTarget:(id)target block:(UOEventBlock)block;
- (void)removeObserverWithTarget:(id)target block:(UOEventBlock)block;

- (void)addObserverTarget:(id)target action:(SEL)action;
- (void)removeObserverTarget:(id)target action:(SEL)action;

- (void)postEventWithType:(UOEventType)type;
- (void)postEventWithType:(UOEventType)type userInfo:(NSDictionary *)userInfo;

- (void)edit:(UOEditBlock)block;
- (void)destroy;

@end