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

@implementation Company(Operation)
+(void)queryFromServer:(void(^)(Company *company))completion
{
    NSDictionary *parameter = @{
                                @"company_id":[LoginUser shareInstance].companyId
                                };
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [[YGRestClient sharedInstance] postForObjectWithUrl:CompanyInfomationUrl form:parameter success:^(id responseObject) {
        NSError *error = nil;
        Company *company = [MTLJSONAdapter modelOfClass:[Company class] fromJSONDictionary:responseObject error:&error];
        if (company) {
            [company save];
            if (completion) {
                completion(company);
            }
        }
        if (error) {
            NSLog(@"%@",error);
        }
    } failure:^(NSError *error) {
        
    }];
}

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    NSError *error;
    NSDictionary *parameter = [MTLJSONAdapter JSONDictionaryFromModel:model error:&error];
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [[YGRestClient sharedInstance] postForObjectWithUrl:ModCompanyUrl form:parameter success:success failure:failure];
}
@end