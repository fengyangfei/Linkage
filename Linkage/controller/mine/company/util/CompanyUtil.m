//
//  CompanyUtil.m
//  Linkage
//
//  Created by Mac mini on 16/6/13.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CompanyUtil.h"
#import "Company.h"
#import "LoginUser.h"

@implementation CompanyUtil

+(Class)modelClass
{
    return [Company class];
}

+(void)queryModelFromServer:(void(^)(id<MTLJSONSerializing> model))completion
{
    Company *temp = [[Company alloc]init];
    temp.companyId = [LoginUser shareInstance].companyId;
    [self queryModelFromServer:temp completion:completion];
}

+(void)queryModelFromServer:(id<MTLJSONSerializing,ModelHttpParameter>)parameter completion:(void(^)(id<MTLJSONSerializing> result))completion
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:CompanyInfomationUrl form:[parameter httpParameterForDetail] success:^(id responseObject) {
        NSError *error = nil;
        Company *company = [MTLJSONAdapter modelOfClass:[Company class] fromJSONDictionary:responseObject error:&error];
        if (company) {
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

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
{
    NSDictionary *parameter = [self jsonFromModel:model];
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [[YGRestClient sharedInstance] postForObjectWithUrl:ModCompanyUrl form:parameter success:success failure:failure];
}

@end
