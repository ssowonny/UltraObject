//
//  UOObject+Protected.h
//  Pods
//
//  Created by Sungwon Lee on 8/6/15.
//
//

#import "UOObject.h"

@interface UOObject (Protected)
+ (Class)UOClass;

- (Class)UOClass;
- (instancetype)initWithID:(UOID)ID;
- (BOOL)importDictionary:(NSDictionary*)dict;
@end