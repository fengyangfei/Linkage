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
                             @"name":@"driver_name",
                             @"mobile":@"company_mobile"
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
-(NSDictionary *)httpParameterForList
{
    return @{
             @"cid":[LoginUser shareInstance].cid,
             @"token":[LoginUser shareInstance].token
             };
}

-(NSDictionary *)httpParameterForDetail
{
    return @{
             @"cid":[LoginUser shareInstance].cid,
             @"token":[LoginUser shareInstance].token,
             @"driver_id":self.driverId?self.driverId:[NSNull null]
             };
}


@end
