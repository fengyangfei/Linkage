//
//  TRTheme.m
//  YGTravel
//
//  Created by Mac mini on 16/1/26.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

//文字与颜色的描述
#import "TRTheme.h"
#import "RMMapper.h"

@implementation TRTheme

+ (TRTheme *)populateThemes:(NSDictionary *)themeDic{
    TRTheme *theme = [[TRTheme alloc] init];
    NSDictionary* properties = [RMMapper propertiesForClass:self.class];
    for (NSString *property in properties) {
        NSString *propertyType = properties[property];
        if (!propertyType) {
            continue;
        }
        NSString *dataKey = [NSString stringWithFormat:@"%c%@", toupper([property characterAtIndex:0]), [property substringFromIndex:1]];
        id value = themeDic[dataKey];
        if (!value) {
            continue;
        }
        Class cls = NSClassFromString(propertyType);
        if ([cls isSubclassOfClass:UIColor.class]) {
            if (![value isKindOfClass:NSString.class]) {
                value = [value description];
            }
            //将颜色值转换成数字类型
            UInt64 hexColor =  strtoul([value UTF8String], 0, 16);
            value = HEXCOLOR(hexColor);
        }
        [theme setValue:value forKey:property];
    }
    return theme;
}

@end
