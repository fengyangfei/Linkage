//
//  DriverUtil.m
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverUtil.h"
#import "Driver.h"
#import "DriverModel.h"
#import "LoginUser.h"
#import <Mantle/Mantle.h>

@implementation DriverUtil

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    NSDictionary *paramter = [self jsonFromModel:model];
    if (paramter) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:AddDriverUrl form:paramter success:success failure:failure];
    }
}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    Driver *driver = (Driver *)model;
    if (driver.driverId) {
        DriverModel *existModel = [DriverModel MR_findFirstByAttribute:@"driverId" withValue:driver.driverId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        driver.userId = [LoginUser shareInstance].userId;
        DriverModel *driverModel = [MTLManagedObjectAdapter managedObjectFromModel:driver insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (driverModel && !error) {
            if (completion) {
                completion();
            }
        }else{
            NSLog(@"同步到数据库失败 - %@",error);
        }
    }
}

+(id<MTLJSONSerializing>)modelFromJson:(NSDictionary *)json
{
    NSError *error;
    Driver *driver = [MTLJSONAdapter modelOfClass:[Driver class] fromJSONDictionary:json error:&error];
    return driver;
}

+(id<MTLJSONSerializing>)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSError *error;
    Driver *driver = [MTLJSONAdapter modelOfClass:[Driver class] fromJSONDictionary:formValues error:&error];
    return driver;
}

+(id<MTLJSONSerializing>)modelFromManagedObject:(NSManagedObject *)managedObject
{
    return nil;
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

@end
