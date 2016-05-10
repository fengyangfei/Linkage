//
//  SOImageModel.m
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SOImage.h"
#import "OrderModel.h"

@implementation SOImage
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:@[@"image"]];
    return keys;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([SOImageModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:@[@"image"]];
    return keys;
}

@end

@implementation NSArray(SOImageModel)
-(NSString *)soImageStringValue
{
    NSMutableString *str = [NSMutableString string];
    for (SOImage *model in self) {
        NSString *mStr = [NSString stringWithFormat:@"%@;", model.imageName];
        [str appendString:mStr];
    }
    return str;
}
@end