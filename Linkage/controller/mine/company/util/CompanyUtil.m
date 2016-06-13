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
    [self queryModelFromServer:[Company shareInstance] completion:completion];
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

@end
