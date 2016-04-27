//
//  Task.m
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Task.h"

@implementation Task
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSString *)managedObjectEntityName
{
    return @"DriverTask";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


@implementation DriverTask
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSString *)managedObjectEntityName
{
    return @"DriverTask";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


@implementation DriverTaskHistory
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSString *)managedObjectEntityName
{
    return @"DriverTaskHistory";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end