//
//  SOImageModel.m
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SOImageModel.h"

@implementation SOImageModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

@end

@implementation NSArray(SOImageModel)
-(NSString *)soImageStringValue
{
    NSMutableString *str = [NSMutableString string];
    for (SOImageModel *model in self) {
        NSString *mStr = [NSString stringWithFormat:@"%@;", model.photoName];
        [str appendString:mStr];
    }
    return str;
}
@end