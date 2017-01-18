//
//  VCRank.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCRank.h"
#import "VCRankModel.h"

@implementation VCRank

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"gid":@"id",
                             @"introduction":@"description",
                             @"visiteCount":@"visitCount",
                             @"createdDate":@"createdDate"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([VCRankModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - 属性转换

+ (NSValueTransformer *)createdDateJSONTransformer
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

+ (NSValueTransformer *)rankJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%ld", (long)[value integerValue]];
        }else if ([value isKindOfClass:[NSString class]]) {
            return value;
        }else{
            return @"";
        }
    }];
}

+ (NSValueTransformer *)visiteCountJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%ld", (long)[value integerValue]];
        }else if ([value isKindOfClass:[NSString class]]) {
            return value;
        }else{
            return @"";
        }
    }];
}

@end
