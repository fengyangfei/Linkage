//
//  CargoModel.m
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import "Cargo.h"
#import "OrderModel.h"

@implementation Cargo
+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName
{
    return [self cargoWithType:type name:cargoName count:@(0) cargoNo:@""];
}

+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName count:(NSNumber *)cargoCount
{
    return [self cargoWithType:type name:cargoName count:cargoCount cargoNo:@""];
}

+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName count:(NSNumber *)cargoCount cargoNo:(NSString *)cargoNo
{
    Cargo *obj = [[Cargo alloc]init];
    obj.cargoType = type;
    obj.cargoName = cargoName;
    obj.cargoCount = cargoCount;
    obj.cargoNo = cargoNo;
    return obj;
}

#pragma mark - MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"cargoType":@"type",
                             @"cargoCount":@"number",
                             @"cargoNo":@"cargono"
                             };
    return keyMap;
}

+ (NSValueTransformer *)cargoTypeJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }else if ([value isKindOfClass:[NSString class]]) {
            return @([value integerValue]);
        }else{
            return @(0);
        }
    }];
}

+ (NSValueTransformer *)cargoCountJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }else if ([value isKindOfClass:[NSString class]]) {
            return @([value integerValue]);
        }else{
            return @(0);
        }
    }];
}

+ (NSValueTransformer *)cargoIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }else if ([value isKindOfClass:[NSString class]]) {
            return @([value integerValue]);
        }else{
            return @(0);
        }
    }];
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([CargoModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - XLFormOptionObject

-(NSString *)formDisplayText
{
    return self.cargoName;
}

-(id)formValue
{
    return self.cargoType;
}

@end

@implementation NSArray(CargoModel)
-(NSString *)cargosStringValue
{
    NSMutableString *str = [NSMutableString string];
    for (Cargo *model in self) {
        NSString *mStr = [NSString stringWithFormat:@"%@:%@;", model.cargoType, model.cargoCount];
        [str appendString:mStr];
    }
    if (str.length > 0) {
        return [str substringToIndex:str.length - 1];
    }
    return str;
}
@end
