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
        uuid = [[NSUserDefaults standardUserDefaults] stringForKey:kUUIDKey];
        if (!uuid) {
            uuid = [NSUUID UUID].UUIDString;
            [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:kUUIDKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
    return uuid;
}

+(NSString *)categoryImageName:(NSString *)category
{
    static NSArray *categories;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categories = @[@"艺术",@"健康",@"家庭",@"青少年",@"新闻",@"参考",@"地区",@"科学",@"购物",@"商业",@"计算机",@"游戏",@"娱乐",@"社会",@"体育"];
    });
    if ([categories containsObject:category]) {
        return category;
    }
    return @"科学";
}

@end
