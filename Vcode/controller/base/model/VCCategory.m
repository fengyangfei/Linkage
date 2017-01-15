//
//  VCCategory.m
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCategory.h"
#import "VCCategoryModel.h"
#import "VCThemeManager.h"

@implementation VCCategory
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

-(NSString *)title
{
    if([VCThemeManager shareInstance].themeType == VCThemeTypeCN){
        return _title;
    }else{
        return _code;
    }
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
