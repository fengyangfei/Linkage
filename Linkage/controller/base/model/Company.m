//
//  Company.m
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Company.h"
#import "LoginUser.h"
#import "YGRestClient.h"
#import <Mantle/Mantle.h>
#define kUserDefalutCompanyKey  @"kUserDefalutCompanyKey"

@implementation Company

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                                @"address":@"contact_address",
                                @"contactorPhone":@"contact_phone",
                                @"url":@"home_page",
                                @"servicePhone2":@"service_phone2",
                                @"servicePhone3":@"service_phone3",
                                @"servicePhone4":@"service_phone4",
                                @"introduction":@"contact_description"
                             };
    NSDictionary *keyDic = [super JSONKeyPathsByPropertyKey];
    return [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
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