//
//  VCCategory.m
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCategory.h"
#import "VCCategoryModel.h"

@implementation VCCategory
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([VCCategoryModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

@end
