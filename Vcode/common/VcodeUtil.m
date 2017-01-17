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
    return @"default";
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
            return VCThemeString(@"google");
        case SearchEngineBing:
            return VCThemeString(@"bing");
        case SearchEngineBaidu:
            return VCThemeString(@"baidu");
        case SearchEngineYahoo:
            return VCThemeString(@"yahoo");
        case SearchEngineHttp:
            return @"HTTP";
        default:
            return VCThemeString(@"google");
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
            return @"";
        default:
            return @"https://www.google.com/search?q=";
            break;
    }
}

+(NSString *)tagBackgroudImage:(NSInteger)x
{
    switch ((x%30)+1){
        case 0:
            return @"30";
        case 1:
            return @"1";
        case 2:
            return @"2";
        case 3:
            return @"3";
        case 4:
            return @"4";
        case 5:
            return @"5";
        case 6:
            return @"6";
        case 7:
            return @"7";
        case 8:
            return @"8";
        case 9:
            return @"9";
        case 10:
            return @"10";
        case 11:
            return @"11";
        case 12:
            return @"12";
        case 14:
            return @"13";
        case 13:
            return @"14";
        case 15:
            return @"15";
        case 16:
            return @"16";
        case 17:
            return @"17";
        case 18:
            return @"18";
        case 19:
            return @"19";
        case 20:
            return @"20";
        case 21:
            return @"21";
        case 22:
            return @"22";
        case 23:
            return @"23";
        case 24:
            return @"24";
        case 25:
            return @"25";
        case 26:
            return @"26";
        case 27:
            return @"27";
        case 28:
            return @"28";
        case 29:
            return @"29";
        default:
            return @"30";
    }
}

+(void)refreshApp
{
    UIViewController *rooViewController = [[VCTabBarController alloc]init];
    VcodeDelegate *delegate = (VcodeDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = rooViewController;
}

@end
