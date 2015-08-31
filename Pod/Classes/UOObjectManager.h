//
//  UOObjectManager.h
//  Pods
//
//  Created by Sungwon Lee on 8/6/15.
//
//

#import <Foundation/Foundation.h>
#import "UOObject.h"

@class UOObject;

@interface UOObjectManager : NSObject

+ (UOObjectManager *)sharedManager;

- (Class)mutableClassWithClass:(Class)klass;
- (id)objectWithClass:(Class)klass forID:(UOID)ID;
- (id)objectWithClass:(Class)klass forJSON:(NSDictionary *)json;
- (void)removeObject:(UOObject *)object;
- (void)setObject:(UOObject *)object forID:(UOID)ID;

@end
