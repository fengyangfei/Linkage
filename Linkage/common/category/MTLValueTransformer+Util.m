//
//  MTLValueTransformer+Util.m
//  Linkage
//
//  Created by Mac mini on 16/9/14.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MTLValueTransformer+Util.h"

@implementation MTLValueTransformer (Util)

+ (MTLValueTransformer *)dateTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id dateString, BOOL *success, NSError *__autoreleasing *error) {
        if ([dateString isKindOfClass:[NSDate class]]) {
            return dateString;
        }else{
            return [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
        }
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        long long dTime = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] longLongValue];
        return @(dTime);
    }];
}

+ (MTLValueTransformer *)numberTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSString class]]) {
            return @([value intValue]);
        }else if ([value isKindOfClass:[NSNumber class]]){
            return value;
        }else{
            return @(0);
        }
    } reverseBlock:^id(id value, BOOL *success, NSError **error) {
        return value;
    }];
}
@end
