//
//  Task.m
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Task.h"
#import "Driver.h"
#import "Cargo.h"

@implementation Task
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"cargoNo":@"cargo_no",
                             @"driverName":@"driver_name",
                             @"driverLicense":@"license"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keys;
}

+(NSValueTransformer *)statusJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSString class]]) {
            return @([value intValue]);
        }else if ([value isKindOfClass:[NSNumber class]]){
            return value;
        }else{
            return @(0);
        }
    } reverseBlock:^id(id value, BOOL *success, NSError **error) {
        return value;
    }];
}

+(NSValueTransformer *)cargoTypeJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSString class]]) {
            return @([value intValue]);
        }else if ([value isKindOfClass:[NSNumber class]]){
            return value;
        }else{
            return @(0);
        }
    } reverseBlock:^id(id value, BOOL *success, NSError **error) {
        return value;
    }];
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return @"TaskModel";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

#pragma mark - initMethod
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        self.updateTime = [NSDate date];
    }
    return self;
}
@end

@implementation Task(Operation)
//司机与货柜组成任务
+ (Task*)createWithDriver:(Driver *)driver cargo:(Cargo *)cargo
{
    Task *task = [[Task alloc]init];
    if (self) {
        if (driver) {
            task.driverId = driver.driverId;
            task.driverName = driver.name;
            task.driverLicense = driver.license;
        }
        if (cargo) {
            task.cargoNo = cargo.cargoNo;
            task.cargoType = cargo.cargoType;
        }
    }
    return task;
}
@end