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

+(void)syncToServer:(MTLModel *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{

}

+(void)syncToDataBase:(MTLModel *)model completion:(MRSaveCompletionHandler)completion
{

}

+(MTLModel *)modelFromJson:(NSDictionary *)json
{
    NSError *error;
    Driver *driver = [MTLJSONAdapter modelOfClass:[Driver class] fromJSONDictionary:json error:&error];
    return driver;
}

+(MTLModel *)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSError *error;
    Driver *driver = [MTLJSONAdapter modelOfClass:[Driver class] fromJSONDictionary:formValues error:&error];
    return driver;
}

+(MTLModel *)modelFromManagedObject:(NSManagedObject *)managedObject
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

+(void)queryModelsFromServer:(MTLModel *)model completion:(void(^)(MTLModel *result))completion
{

}

@end
