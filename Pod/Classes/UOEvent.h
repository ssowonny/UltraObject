//
//  UOEvent.h
//  Pods
//
//  Created by Sungwon Lee on 8/18/15.
//
//

#import <Foundation/Foundation.h>

@class UOObject;

typedef enum : NSUInteger {
    UOEventTypeCreate = -1,
    UOEventTypeUpdate = -2,
    UOEventTypeDelete = -3,
} UOEventType;

@interface UOEvent : NSObject
@property (nonatomic, strong) id object;
@property (nonatomic, assign) UOEventType type;
@property (nonatomic, strong) NSDictionary *userInfo;
@end
