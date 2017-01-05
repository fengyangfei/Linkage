//
//  VcodeUtil.m
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VcodeUtil.h"
#define kUUIDKey @"kUUIDKey"
@implementation VcodeUtil

+(NSString *)UUID
{
    static NSString *uuid;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:kUUIDKey];
        if (!uuid) {
            uuid = [NSUUID UUID].UUIDString;
            [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:kUUIDKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
    return uuid;
}

@end
