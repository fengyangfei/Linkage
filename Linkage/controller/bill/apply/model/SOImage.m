//
//  SOImageModel.m
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SOImage.h"

@implementation SOImage
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
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