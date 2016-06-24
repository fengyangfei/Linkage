//
//  AddressUtil.m
//  Linkage
//
//  Created by lihaijian on 16/4/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressUtil.h"
#import "Address.h"
#import "AddressModel.h"
#import "LoginUser.h"
#import <XLForm/XLForm.h>

@implementation AddressUtil
+(Class)modelClass
{
    return [Address class];
}

+(id<MTLJSONSerializing>)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSError *error;
    Address *model = [MTLJSONAdapter modelOfClass:[self modelClass] fromJSONDictionary:formValues error:&error];
    model.title = [formValues[@"addOption"] valueData];
    if (error) {
        NSLog(@"Form转对象失败 - %@",error);
    }
    return model;
}

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    NSDictionary *paramter = [self jsonFromModel:model];
    paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:[LoginUser shareInstance].baseHttpParameter];
    //paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:@{@"title": ((Address *)model).title}];
    if (paramter) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:AddAddressUrl form:paramter success:success failure:failure];
    }
}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    Address *add = (Address *)model;
    if (add.addressId) {
        AddressModel *existModel = [AddressModel MR_findFirstByAttribute:@"addressId" withValue:add.addressId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        add.userId = [LoginUser shareInstance].cid;
        AddressModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:add insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (addModel && !error) {
            if (completion) {
                completion();
            }
        }else{
            NSLog(@"同步到数据库失败 - %@",error);
        }
    }
}

+(void)deleteFromServer:(id<MTLJSONSerializing,ModelHttpParameter>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    if (model.httpParameterForDetail) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:DelAddressUrl form:model.httpParameterForDetail success:success failure:failure];
    }
}

+(void)deleteFromDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    Address *add = (Address *)model;
    if (add.addressId) {
        AddressModel *existModel = [AddressModel MR_findFirstByAttribute:@"addressId" withValue:add.addressId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        if (completion) {
            completion();
        }
    }
}

//数据库查询
+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"userId", [LoginUser shareInstance].cid];
    [self queryModelsFromDataBase:predicate completion:completion];
}

+(void)queryModelsFromDataBase:(NSPredicate *)predicate completion:(void(^)(NSArray *models))completion
{
    NSArray *managerObjects = [AddressModel MR_findAllSortedBy:@"address" ascending:NO withPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:managerObjects.count];
    for (NSManagedObject *manageObj in managerObjects) {
        id<MTLJSONSerializing> model = [self modelFromManagedObject:manageObj];
        [mutableArray addObject:model];
    }
    if (completion) {
        completion([mutableArray copy]);
    }
}

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:AddressUrl form:[LoginUser shareInstance].baseHttpParameter success:^(id responseObject) {
        if (responseObject[@"addresses"] && [responseObject[@"addresses"] isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject[@"addresses"] error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(array);
            }
        }else{
            completion(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
