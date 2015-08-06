//
//  UOObject.h
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import <Foundation/Foundation.h>

#define UOObjectIDKey @"id"

typedef id<NSCoding, NSCopying> UOID;

@interface UOObject : NSObject<NSCopying, NSMutableCopying>
@property (nonatomic, readonly) UOID ID;
+ (instancetype)objectWithID:(UOID)ID;
+ (instancetype)objectWithJSON:(NSDictionary *)json;

- (void)loadJSON:(NSDictionary *)json;
- (NSDictionary *)toJSON;
@end