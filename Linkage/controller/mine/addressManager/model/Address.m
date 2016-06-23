//
//  Address.m
//  Linkage
//
//  Created by Mac mini on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Address.h"
#import "AddressModel.h"
#import "LoginUser.h"
#import "LinkUtil.h"

@implementation Address

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"addressId":@"address_id"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

+(NSValueTransformer *)titleJSONTransformer
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

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([AddressModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - ModelHttpParameter
-(NSDictionary *)httpParameterForDetail
{
    if (!self.addressId) {
        return nil;
    }
    NSDictionary *baseParameter = [LoginUser shareInstance].baseHttpParameter;
    NSDictionary *paramter = [baseParameter mtl_dictionaryByAddingEntriesFromDictionary:@{@"address_id": self.addressId}];
    return paramter;
}


#pragma mark - XLFormTitleOptionObject
-(NSString *)formTitleText
{
    return [[LinkUtil addressTypes] objectForKey:self.title];
}

-(NSString *)formDisplayText
{
    return self.address;
}

-(id)formValue{
    return self.addressId;
}
@end
