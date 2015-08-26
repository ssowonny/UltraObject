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
#import "UOObject+Protected.h"

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

- (id)objectWithClass:(Class)klass forJSON:(NSDictionary *)json {
    UOID ID;
    UOObject *object;
    NSString *idKey = [klass performSelector:@selector(idKey)];
    if (idKey && (ID = json[idKey])) {
        object = [self objectWithClass:klass forID:ID];
    } else {
        object = [klass new];
    }
    [object importDictionary:json];
    return object;
}

- (id)objectWithClass:(Class)klass forID:(UOID)ID { @synchronized(self) {
    NSAssert(ID, @"`ID` shouldn't be nil for classes that have `idKey`.");
    
    NSMutableDictionary *objects = [self dictionaryForClass:klass];
    NSValue *value = objects[ID];
    UOObject *object = [value nonretainedObjectValue];
    if (!object) {
        object = [[klass alloc] initWithID:ID];
        objects[ID] = [NSValue valueWithNonretainedObject:object];
    }
    
    return object;
} }

- (void)removeObject:(UOObject *)object { @synchronized(self) {
    NSMutableDictionary *objects = [self dictionaryForClass:object.UOClass];
    if (object.__id && [[objects[object.__id] nonretainedObjectValue] isEqual:object]) {
        [objects removeObjectForKey:object.__id];
    }
} }

#pragma mark - Private

- (NSMutableDictionary *)dictionaryForClass:(Class)klass {
    NSString *classKey = NSStringFromClass(klass);
    NSMutableDictionary *objects = _classObjects[classKey];
    if (!objects) {
        objects = [NSMutableDictionary new];
        _classObjects[classKey] = objects;
    }
    
    return objects;
}

- (void)initMutableClasses {
    NSMutableDictionary *mutableClasses = [NSMutableDictionary new];
    
    Class* classes = NULL;
    int classesCount = objc_getClassList(NULL, 0);
    if (classesCount > 0 ) {
        classes = (Class *)malloc(sizeof(Class) * classesCount);
        classesCount = objc_getClassList(classes, classesCount);
        for (int index = 0; index < classesCount; ++ index) {
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


