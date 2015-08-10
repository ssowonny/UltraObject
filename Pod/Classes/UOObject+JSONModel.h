//
//  UOObject+JSONModel.h
//  Pods
//
//  Created by Sungwon Lee on 8/10/15.
//
//

#import "UOObject.h"

@interface UOObject (JSONModel)
- (JSONKeyMapper *)__keyMapper;
- (BOOL)__importDictionary:(NSDictionary*)dict withKeyMapper:(JSONKeyMapper*)keyMapper validation:(BOOL)validation error:(NSError**)err;
@end
