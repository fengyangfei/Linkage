//
//  Order.m
//  Linkage
//
//  Created by lihaijian on 16/3/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Order.h"
#import "Cargo.h"

@implementation Order
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keys;
}

+ (NSString *)managedObjectEntityName
{
    return @"Order";
}

+ (NSValueTransformer *)cargosJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Cargo class]];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)takeTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if (JSONDictionary[@"cargoNo"] != nil) {
        return [ImportOrder class];
    }
    if (JSONDictionary[@"shipName"] != nil) {
        return [ExportOrder class];
    }
    return self;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

@end

@implementation ImportOrder
//进口
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"orderId":@"order_id",
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
                             @"deliverTime":@"delivery_time",
                             @"cargosCentExpire":@"cargos_rent_expire",
                             @"billNo":@"bill_no",
                             @"cargoNo":@"cargo_no",
                             @"cargoCompany":@"cargo_company",
                             @"customsBroker":@"customs_broker",
                             @"customsHouseContact":@"customs_contact",
                             @"isTransferPort":@"is_transfer_port",
                             @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keys;
}
@end

@implementation ExportOrder
//出口
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"orderId":@"order_id",
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
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

@end

@implementation SelfOrder
//自备柜
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
                             @"deliverTime":@"delivery_time",
                             @"isCustomsDeclare":@"is_customs_declare",
                             @"customsIn":@"customs_in",
                             @"cargoTakeTime":@"cargo_take_time",
                             @"isTransferPort":@"is_transfer_port",
                             @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keys;
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
