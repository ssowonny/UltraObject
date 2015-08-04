//
//  NSString+Conversion.m
//  Pods
//
//  Originally created by Paris Xavier Pinkney.
//  https://coderwall.com/p/gji2kg/nsstring-camel-case-snake-case
//  Created by Sungwon Lee on 8/4/15.
//
//

#import "NSString+Conversion.h"

@implementation NSString (Conversion)

- (NSString *)camelCase {
    NSArray *components = [self componentsSeparatedByString:@"_"];
    NSMutableString *camelCaseString = [NSMutableString string];
    [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger index, BOOL *stop) {
        [camelCaseString appendString:(index == 0 ? component : [component capitalizedString])];
        if (index > 0) {
            [camelCaseString appendString:[component capitalizedString]];
        } else {
            [camelCaseString appendString:component];
        }
    }];
    return [camelCaseString copy];
}

- (NSString *)snakeCase {
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    NSUInteger length = self.length;
    for (NSUInteger index = 0; index < length; ++ index) {
        unichar c = [self characterAtIndex:index];
        if ([uppercase characterIsMember:c]) {
            if (index != 0) {
                [output appendString:@"_"];
            }
            [output appendFormat:@"%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return [NSString stringWithString:output];
}

@end
