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
#import "SOImage.h"

@implementation CompanyUtil

+(Class)modelClass
{
    return [Company class];
}

+(id<MTLJSONSerializing>)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSArray *formPhotos = formValues[@"photos"];
    NSArray *formPhones = formValues[@"customerPhones"];
    Company *company = [MTLJSONAdapter modelOfClass:[Company class] fromJSONDictionary:formValues error:nil];
    //设置企业头像值
    company.logo = [Company shareInstance].logo;
    company.images = [formPhotos soImageStringValue];
    if (formPhones && formPhones.count > 0) {
        company.servicePhone = formPhones[0];
    }
    if (formPhones && formPhones.count > 1) {
        company.servicePhone2 = formPhones[1];
    }
    if (formPhones && formPhones.count > 2) {
        company.servicePhone3 = formPhones[2];
    }
    if (formPhones && formPhones.count > 3) {
        company.servicePhone4 = formPhones[3];
    }
    return company;
}

+(NSDictionary *)jsonFromModel:(id<MTLJSONSerializing>)model
{
    Company *company = (Company *)model;
    NSError *error;
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:model error:&error];
    if (StringIsNotEmpty(company.address)) {
        [dic setValue:company.address forKey:@"address"];
    }
    if (StringIsNotEmpty(company.introduction)) {
        [dic setValue:company.introduction forKey:@"description"];
    }
    if (StringIsNotEmpty(company.servicePhone)) {
        [dic setValue:company.servicePhone forKey:@"phone_1"];
    }
    if (StringIsNotEmpty(company.servicePhone2)) {
        [dic setValue:company.servicePhone2 forKey:@"phone_2"];
    }
    if (StringIsNotEmpty(company.servicePhone3)) {
        [dic setValue:company.servicePhone3 forKey:@"phone_3"];
    }
    if (StringIsNotEmpty(company.servicePhone4)) {
        [dic setValue:company.servicePhone4 forKey:@"phone_4"];
    }
    if (error) {
        NSLog(@"对象转换字典失败 - %@",error);
    }
    return dic;
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

//服务端查询
+(void)queryModelsFromServer:(NSDictionary *)parameter url:(NSString *)url completion:(void(^)(NSArray *models))completion
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:url form:parameter success:^(id responseObject) {
        if (responseObject[@"companies"] && [responseObject[@"companies"] isKindOfClass:[NSArray class]]) {
            NSArray *jsonArray = responseObject[@"companies"];
            NSMutableArray *models = [NSMutableArray arrayWithCapacity:jsonArray.count];
            for (NSDictionary *JSONDictionary in jsonArray){
                id<MTLJSONSerializing> model = [self modelFromJson:JSONDictionary];
                if (model == nil){continue;}
                [models addObject:model];
            }
            if (completion) {
                completion(models);
            }
        }else{
            completion(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
{
    NSDictionary *parameter = [self jsonFromModel:model];
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [[YGRestClient sharedInstance] postForObjectWithUrl:ModCompanyUrl form:parameter success:success failure:failure];
}

@end
