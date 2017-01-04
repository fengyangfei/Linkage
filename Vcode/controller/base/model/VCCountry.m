//
//  VCCountry.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCountry.h"

@implementation VCCountry
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark -- XLFormOptionObject
-(NSString *)formDisplayText
{
    return self.title;
}

-(id)formValue
{
    return self.code;
}
@end
