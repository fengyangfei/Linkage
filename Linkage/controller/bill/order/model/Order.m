//
//  Order.m
//  Linkage
//
//  Created by lihaijian on 16/3/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Order.h"
#import "Cargo.h"
#import "OrderModel.h"

#define kOrderRemoveKeys @[@"cargos",@"companyId",@"userId"]
@implementation Order

#pragma mark - MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

+ (NSValueTransformer *)cargosJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Cargo class]];
}

+ (NSValueTransformer *)takeTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id dateString, BOOL *success, NSError *__autoreleasing *error) {
        if ([dateString isKindOfClass:[NSDate class]]) {
            return dateString;
        }else{
            return [self.dateFormatter dateFromString:dateString];
        }
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if (JSONDictionary[@"cargo_no"] != nil) {
        return [ImportOrder class];
    }
    if (JSONDictionary[@"ship_name"] != nil) {
        return [ExportOrder class];
    }
    return self;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([OrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)cargosEntityAttributeTransformer
{
    return [MTLManagedObjectAdapter transformerForModelPropertiesOfClass:[CargoModel class]];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

@end

/**
 * 进口
 */
@implementation ImportOrder
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"orderId":@"order_id",
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
                             @"deliverTime":@"delivery_time",
                             @"cargosRentExpire":@"cargos_rent_expire",
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
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([ImportOrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end

/**
 * 出口
 */
@implementation ExportOrder
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
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([ExportOrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:@[@"so"]];
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
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
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
