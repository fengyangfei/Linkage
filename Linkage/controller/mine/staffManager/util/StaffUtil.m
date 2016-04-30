//
//  StaffUtil.m
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "StaffUtil.h"
#import "Staff.h"
#import "StaffModel.h"
#import "LoginUser.h"

@implementation StaffUtil
+(Class)modelClass
{
    return [Staff class];
}

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    NSDictionary *paramter = [self jsonFromModel:model];
    paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:[LoginUser shareInstance].baseHttpParameter];
    if (paramter) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:AddStaffUrl form:paramter success:success failure:failure];
    }
}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    Staff *staff = (Staff *)model;
    if (staff.staffId) {
        StaffModel *existModel = [StaffModel MR_findFirstByAttribute:@"staffId" withValue:staff.staffId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        staff.userId = [LoginUser shareInstance].cid;
        StaffModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:staff insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
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
        [[YGRestClient sharedInstance] postForObjectWithUrl:DelStaffUrl form:model.httpParameterForDetail success:success failure:failure];
    }
}

+(void)deleteFromDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    Staff *staff = (Staff *)model;
    if (staff.staffId) {
        StaffModel *existModel = [StaffModel MR_findFirstByAttribute:@"staffId" withValue:staff.staffId inContext:[NSManagedObjectContext MR_defaultContext]];
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
    NSArray *managerObjects = [StaffModel MR_findByAttribute:@"userId" withValue:[LoginUser shareInstance].cid inContext:[NSManagedObjectContext MR_defaultContext]];
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
    [[YGRestClient sharedInstance] postForObjectWithUrl:StaffsUrl form:[LoginUser shareInstance].basePageHttpParameter success:^(id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject error:&error];
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
