//
//  VcodeUtil.m
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VcodeUtil.h"
#import "VCTabBarController.h"
#import "VcodeDelegate.h"
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

+(NSString *)searchImage:(SearchEngine)searchEngine
{
    switch (searchEngine) {
        case SearchEngineGoogle:
            return @"google";
        case SearchEngineBing:
            return @"bing";
        case SearchEngineBaidu:
            return @"baidu";
        case SearchEngineYahoo:
            return @"yahoo";
        case SearchEngineHttp:
            return @"ihttp";
        default:
            return @"google";
            break;
    }
}

+(NSString *)searchName:(SearchEngine)searchEngine
{
    switch (searchEngine) {
        case SearchEngineGoogle:
            return @"谷歌";
        case SearchEngineBing:
            return @"必应";
        case SearchEngineBaidu:
            return @"百度";
        case SearchEngineYahoo:
            return @"雅虎";
        case SearchEngineHttp:
            return @"HTTP";
        default:
            return @"谷歌";
            break;
    }
}

+(NSString *)searchUrl:(SearchEngine)searchEngine
{
    switch (searchEngine) {
        case SearchEngineGoogle:
            return @"https://www.google.com/search?q=";
        case SearchEngineBing:
            return @"http://www.bing.com/search?q=";
        case SearchEngineBaidu:
            return @"https://www.baidu.com/s?wd=";
        case SearchEngineYahoo:
            return @"https://search.yahoo.com/search?p=";
        case SearchEngineHttp:
            return @"https://www.baidu.com/s?wd=";
        default:
            return @"https://www.google.com/search?q=";
            break;
    }
}

+(void)refreshApp
{
    UIViewController *rooViewController = [[VCTabBarController alloc]init];
    VcodeDelegate *delegate = (VcodeDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = rooViewController;
}

@end
