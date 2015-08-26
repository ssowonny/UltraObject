//
//  UOObject+Protected.h
//  Pods
//
//  Created by Sungwon Lee on 8/6/15.
//
//

#import "UOObject.h"

@interface UOObject (Protected)
@property (nonatomic, readonly) UOID __id;

+ (NSString *)__idKey;
+ (Class)UOClass;

- (Class)UOClass;
- (instancetype)initWithID:(UOID)ID;
- (BOOL)importDictionary:(NSDictionary*)dict;
@end