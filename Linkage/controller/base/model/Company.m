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
                                @"introduction":@"description"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
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