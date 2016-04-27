//
//  DriverUtil.m
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverUtil.h"
#import "Driver.h"
#import <Mantle/Mantle.h>

@implementation DriverUtil

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{

}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{

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
    return [MTLJSONAdapter JSONDictionaryFromModel:model error:&error];
}

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{

}

+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion
{
    
}

+(void)queryModelsFromServer:(id)model completion:(void(^)(id<MTLJSONSerializing> result))completion
{

}

@end
