//
//  VCCountryUtil.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCountryUtil.h"
#import "VCCountry.h"

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
@end
