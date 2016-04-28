//
//  Car.m
//  Linkage
//
//  Created by lihaijian on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Car.h"
#import "CarModel.h"
#import "LoginUser.h"

@implementation Car

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"carId":@"car_id",
                             @"engineNo":@"engine_no",
                             @"frameNo":@"frame_no",
                             @"applyDate":@"apply_date",
                             @"examineData":@"examine_data",
                             @"maintainData":@"maintain_data",
                             @"trafficInsureData":@"traffic_insure_data",
                             @"businessInsureData":@"business_insure_data",
                             @"insureCompany":@"insure_company"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([CarModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - ModelHttpParameter
-(NSDictionary *)httpParameterForDetail
{
    if (!self.carId) {
        return nil;
    }
    NSDictionary *baseParameter = [LoginUser shareInstance].baseHttpParameter;
    NSDictionary *paramter = [baseParameter mtl_dictionaryByAddingEntriesFromDictionary:@{@"car_id": self.carId}];
    return paramter;
}


@end
