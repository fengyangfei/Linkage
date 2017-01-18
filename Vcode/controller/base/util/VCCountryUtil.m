//
//  VCCountryUtil.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCountryUtil.h"
#import "VCCountry.h"
#import "NSString+PingYinChar.h"

#define kCountryIndex @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",@"k", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"]

@implementation VCCountryUtil
+(Class)modelClass{ return [VCCountry class]; }

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{
    NSError *error;
    NSURL *countryUrl = [[NSBundle mainBundle] URLForResource:@"country" withExtension:@"plist"];
    NSArray *list = [NSArray arrayWithContentsOfURL:countryUrl];
    NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:list error:&error];
    completion(array);
}

//生成分组对象
+(NSDictionary *)generateDicFromArray:(NSArray *)array
{
    NSMutableDictionary *countryDic = [NSMutableDictionary dictionary];
    NSArray *availKeys = kCountryIndex;
    for (NSString *key in availKeys) {
        //先初始化所有的组
        countryDic[key] = [NSMutableArray array];
    }
    NSMutableArray *countriesFromKey;
    for (int i =0 ; i < [array count]; i++) {
        VCCountry *country = [array objectAtIndex:i];
        if (country.title && country.title.length > 1) {
            NSString *k = [[[country.title pinyinInitial] substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            if ([k characterAtIndex:0] < 'A' || [k characterAtIndex:0] > 'Z') {
                countriesFromKey = countryDic[@"#"];
            }else{
                countriesFromKey = countryDic[k];
            }
        }else{
            countriesFromKey = countryDic[@"#"];
        }
        //为每一组添加对象
        [countriesFromKey addObject:country];
    }
    return countryDic;
}

@end
