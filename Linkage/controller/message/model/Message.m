//
//  Message.m
//  Linkage
//
//  Created by lihaijian on 16/5/1.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Message.h"
#import "MessageModel.h"
#import "LoginUser.h"

@implementation Message

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"messageId":@"id",
                             @"introduction":@"description",
                             @"createTime":@"create_time"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([MessageModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - 属性转换
+ (NSValueTransformer *)messageIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        }else if ([value isKindOfClass:[NSNumber class]]){
            return [NSString stringWithFormat:@"%@", value];
        }else{
            return @"";
        }
    } reverseBlock:^id(id value, BOOL *success, NSError **error) {
        return value;
    }];
}

+(NSValueTransformer *)typeJSONTransformer
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

+ (NSValueTransformer *)createTimeJSONTransformer
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

#pragma mark - ModelHttpParameter
-(NSDictionary *)httpParameterForDetail
{
    if (!self.messageId) {
        return nil;
    }
    NSDictionary *baseParameter = [LoginUser shareInstance].baseHttpParameter;
    NSDictionary *paramter = [baseParameter mtl_dictionaryByAddingEntriesFromDictionary:@{@"message_id": self.messageId}];
    return paramter;
}

@end
