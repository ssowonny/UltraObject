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

@interface UOObject (UOObjectManager)
- (instancetype)initWithID:(UOID)ID;
@property (nonatomic, strong) NSMutableDictionary *objectAttributes;
@end

@interface UOObjectManager () {
    NSDictionary *_mutableClasses;
    NSMutableDictionary *_classObjects;
}
@end

@implementation UOObjectManager

+ (UOObjectManager *)sharedManager {
    if (!__sharedManager) {
        __sharedManager = [UOObjectManager new];
    }
    return __sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMutableClasses];
        _classObjects = [NSMutableDictionary new];
    }
    return self;
}

- (Class)mutableClassWithClass:(Class)klass {
    return _mutableClasses[NSStringFromClass(klass)];
}

- (id)objectWithClass:(Class)klass forID:(UOID)ID {
    NSString *classKey = NSStringFromClass(klass);
    NSMutableDictionary *objects = _classObjects[classKey];
    if (!objects) {
        objects = [NSMutableDictionary new];
        _classObjects[classKey] = objects;
    }
    
    UOObject *object = objects[ID];
    if (!object) {
        object = [[klass alloc] initWithID:ID];
        objects[ID] = object;
    }
    
    return object;
}

- (id)objectWithClass:(Class)klass forJSON:(NSDictionary *)json {
    UOID ID = json[UOObjectIDKey];
    UOObject *object = [self objectWithClass:klass forID:ID];
    [object mergeFromDictionary:json useKeyMapping:YES];
    return object;
}

#pragma mark - Private

- (void)initMutableClasses {
    NSMutableDictionary *mutableClasses = [NSMutableDictionary new];
    
    Class* classes = NULL;
    int classesCount = objc_getClassList(NULL, 0);
    if (classesCount > 0 ) {
        classes = (Class *)malloc(sizeof(Class) * classesCount);
        classesCount = objc_getClassList(classes, classesCount);
        for (int index = 0; index < classesCount; index++) {
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


