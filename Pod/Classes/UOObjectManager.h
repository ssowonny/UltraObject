//
//  UOObjectManager.h
//  Pods
//
//  Created by Sungwon Lee on 8/6/15.
//
//

#import <Foundation/Foundation.h>

@interface UOObjectManager : NSObject

+ (UOObjectManager *)sharedManager;

- (Class)mutableClassWithClass:(Class)klass;

@end
