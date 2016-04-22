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

+(Cargo *)cargoWithId:(NSNumber *)cargoId name:(NSString *)cargoName count:(NSNumber *)cargoCount
{
    Cargo *obj = [[Cargo alloc]init];
    obj.cargoId = cargoId;
    obj.cargoName = cargoName;
    obj.cargoCount = cargoCount;
    return obj;
}

#pragma mark - MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
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

+ (NSValueTransformer *)orderEntityAttributeTransformer
{
    return [MTLManagedObjectAdapter transformerForModelPropertiesOfClass:[OrderModel class]];
}

#pragma mark - XLFormOptionObject

-(NSString *)formDisplayText
{
    return self.cargoName;
}

-(id)formValue
{
    return self.cargoId;
}

@end

@implementation NSArray(CargoModel)
-(NSString *)cargosStringValue
{
    NSMutableString *str = [NSMutableString string];
    for (Cargo *model in self) {
        NSString *mStr = [NSString stringWithFormat:@"%@:%@;", model.cargoId, model.cargoCount];
        [str appendString:mStr];
    }
    return str;
}
@end
