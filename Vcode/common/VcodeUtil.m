//
//  VcodeUtil.m
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VcodeUtil.h"

@implementation VcodeUtil

+(NSString *)UUID
{
    static NSString *uuid;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uuid = [NSUUID UUID].UUIDString;
    });
    return uuid;
}

@end
