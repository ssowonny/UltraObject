//
//  UOObjectManager.m
//  Pods
//
//  Created by Sungwon Lee on 8/6/15.
//
//

#import "UOObjectManager.h"
#import <objc/runtime.h>
#import "UOMutableObject.h"

static UOObjectManager *__sharedManager;

@interface UOObjectManager () {
    NSDictionary *_mutableClasses;
}
@end

@implementation UOObjectManager

+ (UOObjectManager *)sharedManager {
    if (!__sharedManager) {
        __sharedManager = [UOObjectManager new];
    }
    return __sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initMutableClasses];
    }
    return self;
}

- (Class)mutableClassWithClass:(Class)klass {
    return _mutableClasses[NSStringFromClass(klass)];
}

#pragma mark - Private

- (void)initMutableClasses {
    NSMutableDictionary *mutableClasses = [NSMutableDictionary new];
    
    Class* classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 ) {
        classes = (Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int index = 0; index < numClasses; index++) {
            Class class = classes[index];
            if (class_conformsToProtocol(class, @protocol(UOMutableObject))) {
                Class superClass = class_getSuperclass(class);
                NSString *superClassKey = NSStringFromClass(superClass);
                mutableClasses[superClassKey] = class;
            }
        }
        free(classes);
    }
    
    _mutableClasses = [NSDictionary dictionaryWithDictionary:mutableClasses];
}

@end
