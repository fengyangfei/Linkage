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
#import "SOImage.h"
#import "Task.h"
#import "LoginUser.h"

#define kOrderRemoveKeys @[@"cargos",@"userId",@"objStatus",@"soImages"]
#define kOrderManageObjectRemoveKeys @[@"objStatus",@"tasks"]
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

+ (NSValueTransformer *)typeJSONTransformer
{
    NSDictionary *transDic = @{
                               @(0): @(OrderTypeExport),
                               @(1): @(OrderTypeImport),
                               @(2): @(OrderTypeMainland),
                               @(3): @(OrderTypeSelf)
                               };
    return [MTLValueTransformer
            transformerUsingForwardBlock:^ id (id key, BOOL *success, NSError **error) {
                if ([key isKindOfClass:[NSString class]]) {
                    return transDic[@([key integerValue]) ?: NSNull.null] ?: @(OrderTypeExport);
                }else{
                    return transDic[key ?: NSNull.null] ?: @(OrderTypeExport);
                }
            }
            reverseBlock:^ id (id value, BOOL *success, NSError **error) {
                __block id result = nil;
                [transDic enumerateKeysAndObjectsUsingBlock:^(id key, id anObject, BOOL *stop) {
                    if ([value isEqual:anObject]) {
                        result = key;
                        *stop = YES;
                    }
                }];
                return result ?: @(0);
            }];
}

+ (NSValueTransformer *)statusJSONTransformer
{
    NSDictionary *transDic = @{
                               @(0): @(OrderStatusPending),
                               @(1): @(OrderStatusExecuting),
                               @(2): @(OrderStatusDenied),
                               @(3): @(OrderStatusCompletion),
                               @(4): @(OrderStatusCancelled)
                               };
    return [MTLValueTransformer
            transformerUsingForwardBlock:^ id (id key, BOOL *success, NSError **error) {
                if ([key isKindOfClass:[NSString class]]) {
                    return transDic[@([key integerValue]) ?: NSNull.null] ?: @(OrderStatusPending);
                }else{
                    return transDic[key ?: NSNull.null] ?: @(OrderStatusPending);
                }
            }
            reverseBlock:^ id (id value, BOOL *success, NSError **error) {
                __block id result = nil;
                [transDic enumerateKeysAndObjectsUsingBlock:^(id key, id anObject, BOOL *stop) {
                    if ([value isEqual:anObject]) {
                        result = key;
                        *stop = YES;
                    }
                }];
                return result ?: @(0);
            }];
}

+(NSValueTransformer *)isTransferPortJSONTransformer
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

+ (NSValueTransformer *)tasksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Task class]];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([@[@"takeTime",@"deliverTime",@"cargosRentExpire",@"createTime",@"updateTime",@"customsIn",@"cargoTakeTime"] containsObject:key]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id dateString, BOOL *success, NSError *__autoreleasing *error) {
            if ([dateString isKindOfClass:[NSDate class]]) {
                return dateString;
            }else{
                return [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
            }
        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            long long dTime = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] longLongValue];
            return @(dTime);
        }];
    }
    return nil;
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if (JSONDictionary[@"cargo_no"] != nil) {
        return [ImportOrder class];
    }
    if (JSONDictionary[@"ship_name"] != nil) {
        return [ExportOrder class];
    }
    if (JSONDictionary[@"is_customs_declare"] != nil) {
        return [SelfOrder class];
    }
    
    if ([JSONDictionary[@"type"] integerValue] == OrderTypeExport) {
        return [ExportOrder class];
    }else if ([JSONDictionary[@"type"] integerValue] == OrderTypeImport){
        return [ImportOrder class];
    }else if ([JSONDictionary[@"type"] integerValue] == OrderTypeSelf){
        return [SelfOrder class];
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
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderManageObjectRemoveKeys];
    return keys;
}

+ (NSValueTransformer *)cargosEntityAttributeTransformer
{
    return [MTLManagedObjectAdapter transformerForModelPropertiesOfClass:[CargoModel class]];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"cargos":[Cargo class],@"soImages":[SOImage class]};
}

#pragma mark - ModelHttpParameter
-(NSDictionary *)httpParameterForDetail
{
    NSDictionary *key = @{
                          @"order_id":self.orderId
                          };
    return [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:key];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    return self;
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
                             @"companyId":@"company_id",
                             @"companyName":@"company_name",
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
                             @"updateTime":@"update_time",
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
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderManageObjectRemoveKeys];
    return keys;
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
                             @"companyId":@"company_id",
                             @"companyName":@"company_name",
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
                             @"updateTime":@"update_time",
                             @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

+(NSValueTransformer *)isBookCargoJSONTransformer
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
    return NSStringFromClass([ExportOrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:@[@"so",@"objStatus",@"tasks"]];
    return keys;
}

+ (NSValueTransformer *)soImagesEntityAttributeTransformer
{
    return [MTLManagedObjectAdapter transformerForModelPropertiesOfClass:[SOImageModel class]];
}

@end

@implementation SelfOrder
//自备柜
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"companyId":@"company_id",
                             @"companyName":@"company_name",
                             @"takeAddress":@"take_address",
                             @"takeTime":@"take_time",
                             @"deliveryAddress":@"delivery_address",
                             @"deliverTime":@"delivery_time",
                             @"isCustomsDeclare":@"is_customs_declare",
                             @"customsIn":@"customs_in",
                             @"cargoTakeTime":@"cargo_take_time",
                             @"isTransferPort":@"is_transfer_port",
                             @"updateTime":@"update_time",
                             @"memo":@"memo"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderRemoveKeys];
    return keys;
}

+(NSValueTransformer *)isCustomsDeclareJSONTransformer
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
    return NSStringFromClass([SelfOrderModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:kOrderManageObjectRemoveKeys];
    return keys;
}

@end
