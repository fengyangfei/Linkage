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
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:@[@"image",@"createDate"]];
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
    keys = [keys mtl_dictionaryByRemovingValuesForKeys:@[@"image",@"createDate"]];
    return keys;
}

@end

@implementation NSArray(SOImageModel)
-(NSString *)soImageStringValue
{
    NSMutableString *str = [NSMutableString string];
    for (id each in self) {
        NSString *mStr;
        if ([each isKindOfClass:[SOImage class]]) {
            SOImage *model = (SOImage *)each;
            if(model == self.firstObject){
                mStr = [NSString stringWithFormat:@"%@", model.imageUrl];
            }else{
                mStr = [NSString stringWithFormat:@";%@", model.imageUrl];
            }
        }else if([each isKindOfClass:[NSString class]]){
            if(each == self.firstObject){
                mStr = [NSString stringWithFormat:@"%@", each];
            }else{
                mStr = [NSString stringWithFormat:@";%@", each];
            }
        }
        if (StringIsNotEmpty(mStr)) {
            [str appendString:mStr];
        }
    }
    return str;
}
@end