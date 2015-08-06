//
//  UOObject.h
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

#define UOObjectIDKey @"id"

typedef id<NSCoding, NSCopying> UOID;

@interface UOObject : JSONModel<NSCopying, NSMutableCopying>
@property (nonatomic, readonly) UOID id;

-(instancetype)initWithString:(NSString*)string error:(JSONModelError**)err __attribute__((unavailable("not available")));
-(instancetype)initWithString:(NSString *)string usingEncoding:(NSStringEncoding)encoding error:(JSONModelError**)err __attribute__((unavailable("not available")));
-(instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError **)err __attribute__((unavailable("not available")));
-(instancetype)initWithData:(NSData *)data error:(NSError **)error __attribute__((unavailable("not available")));

+ (instancetype)objectWithID:(UOID)ID;
+ (instancetype)objectWithJSON:(NSDictionary *)json;
@end