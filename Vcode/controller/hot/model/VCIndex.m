//
//  VCIndex.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCIndex.h"

@implementation VCIndex
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

+ (NSValueTransformer *)adsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[VCAd class]];
}

+ (NSValueTransformer *)pagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[VCPage class]];
}
@end


@implementation VCAd
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"gid":@"id"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

+ (NSValueTransformer *)sortJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }else if ([value isKindOfClass:[NSString class]]) {
            return @([value integerValue]);
        }else{
            return @(0);
        }
    }];
}
@end

@implementation VCPage
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"gid":@"id"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

+ (NSValueTransformer *)sortNumberJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }else if ([value isKindOfClass:[NSString class]]) {
            return @([value integerValue]);
        }else{
            return @(0);
        }
    }];
}
@end
