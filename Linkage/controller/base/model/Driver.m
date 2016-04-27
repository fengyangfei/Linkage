//
//  Driver.m
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Driver.h"
#import "LoginUser.h"
#import "DriverModel.h"

@implementation Driver

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"driverId":@"driver_id",
                             @"name":@"driver_name",
                             @"mobile":@"driver_mobile"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

+ (NSValueTransformer *)genderJSONTransformer
{
    NSDictionary *transDic = @{
                               @"F": @(Female),
                               @"M": @(Male)
                               };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transDic defaultValue:@(Male) reverseDefaultValue:@"M"];
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([DriverModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - ModelHttpParameter
-(NSDictionary *)httpParameterForDetail
{
    if (!self.driverId) {
        return nil;
    }
    NSDictionary *baseParameter = [LoginUser shareInstance].baseHttpParameter;
    NSDictionary *paramter = [baseParameter mtl_dictionaryByAddingEntriesFromDictionary:@{@"driver_id": self.driverId}];
    return paramter;
}


@end
