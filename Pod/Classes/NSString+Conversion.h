//
//  NSString+Conversion.h
//  Pods
//
//  Created by Sungwon Lee on 8/4/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Conversion)
@property (nonatomic, readonly) NSString *camelCase;
@property (nonatomic, readonly) NSString *snakeCase;
@end
