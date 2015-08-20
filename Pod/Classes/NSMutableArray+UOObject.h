//
//  NSMutableArray+UOObject.h
//  Pods
//
//  Created by Sungwon Lee on 8/19/15.
//
//

#import <Foundation/Foundation.h>
#import "UOEventCenter.h"

@protocol UOObjectArrayDelegate <NSObject>
@required
- (NSUInteger)objectArray:(NSMutableArray *)array indexOfNewObject:(UOObject *)object;
@optional
- (void)objectArray:(NSMutableArray *)array didReceiveEvent:(UOEvent *)event;
- (BOOL)objectArray:(NSMutableArray *)array shouldAddNewObject:(UOObject *)object;
@end

@interface NSMutableArray (UOObject)
@property (nonatomic, weak, readonly) id<UOObjectArrayDelegate> objectArrayDelegate;
- (void)setObjectArrayDelegate:(id<UOObjectArrayDelegate>)delegate class:(Class)klass;
@end
