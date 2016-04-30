//
//  Favorite.m
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Favorite.h"
#import "LoginUser.h"
#import "FavoriteModel.h"

@implementation Favorite
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"companyId":@"company_id",
                             @"companyName":@"company_name",
                             @"contactName":@"contact_name",
                             @"servicePhone":@"service_phone",
                             @"orderNum":@"order_num"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

+ (NSValueTransformer *)orderNumJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if (value != nil && [value isKindOfClass:[NSNumber class]]) {
            return value;
        }else if (value != nil && [value isKindOfClass:[NSString class]]) {
            return @([value intValue]);
        }else if (value == [NSNull null]) {
            return @(0);
        }else{
            return @(0);
        }
    }];
}

+ (NSValueTransformer *)scoreJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if (value != nil && [value isKindOfClass:[NSNumber class]]) {
            return value;
        }else if (value != nil && [value isKindOfClass:[NSString class]]) {
            return @([value intValue]);
        }else if (value == [NSNull null]) {
            return @(0);
        }else{
            return @(0);
        }
    }];
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([FavoriteModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - ModelHttpParameter
-(NSDictionary *)httpParameterForDetail
{
    if (!self.companyId) {
        return nil;
    }
    NSDictionary *baseParameter = [LoginUser shareInstance].baseHttpParameter;
    NSDictionary *paramter = [baseParameter mtl_dictionaryByAddingEntriesFromDictionary:@{@"company_id": self.companyId}];
    return paramter;
}


#pragma mark - XLFormTitleOptionObject
-(NSString *)formTitleText
{
    return self.companyName;
}

-(NSString *)formDisplayText
{
    return self.companyName;
}

-(id)formValue{
    return self.companyId;
}
@end
