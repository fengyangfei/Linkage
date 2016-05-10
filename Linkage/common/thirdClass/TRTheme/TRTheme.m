//
//  TRTheme.m
//  YGTravel
//
//  Created by Mac mini on 16/1/26.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

//文字与颜色的描述
#import "TRTheme.h"

@implementation TRTheme
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    NSArray *propertyKeys = [self.class propertyKeys].allObjects;
    for (NSString *key in propertyKeys) {
        NSString *plistKey = [NSString stringWithFormat:@"%c%@", toupper([key characterAtIndex:0]), [key substringFromIndex:1]];
        [mutableDic setObject:plistKey forKey:key];
    }
    return [mutableDic copy];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError **error) {
        UInt64 hexColor = strtoul([value UTF8String], 0, 16);
        return HEXCOLOR(hexColor);
    }];
}

@end