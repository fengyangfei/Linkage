//
//  Order.m
//  Linkage
//
//  Created by lihaijian on 16/3/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Order.h"

@implementation Order
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                                @"takeAddress":@"take_address",
                                @"takeTime":@"take_time",
                                @"deliveryAddress":@"delivery_address",
                                @"deliverTime":@"delivery_time",
                                @"deliveryAddress":@"port",
                                @"deliverTime":@"delivery_time",
                                @"port":@"port",
                                @"customsIn":@"customs_in",
                                @"shipCompany":@"ship_company",
                                @"shipName":@"ship_name",
                                @"shipScheduleNo":@"ship_schedule_no",
                                @"isBookCargo":@"is_book_cargo",
                                @"isTransferPort":@"is_transfer_port",
                                @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keys;
}

+ (NSString *)managedObjectEntityName
{
    return @"Order";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end


@implementation ImportOrder
@end

@implementation ExportOrder

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
