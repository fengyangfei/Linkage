//
//  Company.m
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Company.h"
#define kUserDefalutCompanyKey  @"kUserDefalutCompanyKey"

@implementation Company

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                                @"companyId":@"company_id",
                                @"name":@"company_name",
                                @"address":@"contact_address",
                                @"contactor":@"contact_name",
                                @"contactorPhone":@"contact_phone",
                                @"orderNum":@"order_num",
                                @"introduction":@"description"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
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

-(NSString *)formDisplayText
{
    return _name;
}

-(id)formValue
{
    return _companyId;
}

//保存
static Company *company;
-(BOOL)save
{
    company = self;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefalutCompanyKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(Company *)shareInstance
{
    if (!company) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefalutCompanyKey];
        if(data){
            company = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return company;
}

@end

@implementation Car

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

@end