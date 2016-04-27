//
//  CarUtil.m
//  Linkage
//
//  Created by lihaijian on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CarUtil.h"
#import "Car.h"
#import "CarModel.h"
#import "LoginUser.h"
#import <Mantle/Mantle.h>

@implementation CarUtil

+(id<MTLJSONSerializing>)modelFromJson:(NSDictionary *)json
{
    NSError *error;
    Car *car = [MTLJSONAdapter modelOfClass:[Car class] fromJSONDictionary:json error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return car;
}

+(id<MTLJSONSerializing>)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSError *error;
    Car *car = [MTLJSONAdapter modelOfClass:[Car class] fromJSONDictionary:formValues error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return car;
}

+(id<MTLJSONSerializing>)modelFromManagedObject:(NSManagedObject *)managedObject
{
    NSError *error;
    Car *car = [MTLManagedObjectAdapter modelOfClass:[Car class] fromManagedObject:managedObject error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return car;
}

+(NSDictionary *)jsonFromModel:(id<MTLJSONSerializing>)model
{
    NSError *error;
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:model error:&error];
    if (error) {
        NSLog(@"对象转换字典失败 - %@",error);
    }
    return dic;
}

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    NSDictionary *paramter = [self jsonFromModel:model];
    paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:[LoginUser shareInstance].baseHttpParameter];
    if (paramter) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:AddCarUrl form:paramter success:success failure:failure];
    }
}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    Car *car = (Car *)model;
    if (car.carId) {
        CarModel *existModel = [CarModel MR_findFirstByAttribute:@"CarId" withValue:car.carId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        car.userId = [LoginUser shareInstance].cid;
        CarModel *carModel = [MTLManagedObjectAdapter managedObjectFromModel:car insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (carModel && !error) {
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
        [[YGRestClient sharedInstance] postForObjectWithUrl:DelCarUrl form:model.httpParameterForDetail success:success failure:failure];
    }
}

+(void)deleteFromDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    Car *car = (Car *)model;
    if (car.carId) {
        CarModel *existModel = [CarModel MR_findFirstByAttribute:@"CarId" withValue:car.carId inContext:[NSManagedObjectContext MR_defaultContext]];
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
    NSArray *managerObjects = [CarModel MR_findByAttribute:@"userId" withValue:[LoginUser shareInstance].cid inContext:[NSManagedObjectContext MR_defaultContext]];
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
    [[YGRestClient sharedInstance] postForObjectWithUrl:CarsUrl form:[LoginUser shareInstance].baseHttpParameter success:^(id responseObject) {
        if (responseObject[@"Cars"] && [responseObject[@"Cars"] isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[Car class] fromJSONArray:responseObject[@"Cars"] error:&error];
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

+(void)queryModelFromServer:(id<MTLJSONSerializing, ModelHttpParameter>)parameter completion:(void(^)(id<MTLJSONSerializing> result))completion
{
    if (parameter.httpParameterForDetail) {
        Car *(^mergeOrder)(id responseObject) = ^(id responseObject) {
            Car *result = (Car *)[CarUtil modelFromJson:responseObject];
            [result mergeValueForKey:@"CarId" fromModel:parameter];
            return result;
        };
        
        [[YGRestClient sharedInstance] postForObjectWithUrl:CarDetailUrl form:parameter.httpParameterForDetail success:^(id responseObject) {
            Car *result = mergeOrder(responseObject);
            if (completion) {
                completion(result);
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

@end
