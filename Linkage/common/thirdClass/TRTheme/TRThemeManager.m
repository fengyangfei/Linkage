//
//  TRThemeManager.m
//  YGTravel
//
//  Created by Mac mini on 16/1/11.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "TRThemeManager.h"

NSString *const kTRThemeChangeNofication = @"com.ygsoft.travel.theme.change";
NSString *const kTRThemeUserDefaultKey = @"com.ygsoft.travel.theme.current";

@interface TRThemeManager()
@property (nonatomic, strong) NSMutableDictionary *bundleCache;
@end

@implementation TRThemeManager
@synthesize themeType = _themeType;
@synthesize theme = _theme;

static NSDictionary *themeBundleMapping;
+(void)load
{
    themeBundleMapping = @{
                           [NSNumber numberWithInt:TRThemeTypeCompany] : @"Company",
                           [NSNumber numberWithInt:TRThemeTypeSubCompany] :@"SubCompany",
                           [NSNumber numberWithInt:TRThemeTypeContact] :@"Contact",
                           [NSNumber numberWithInt:TRThemeTypeSubContact] :@"SubContact"
                           };
}

+(TRThemeManager *)shareInstance
{
    static TRThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewControllerThemeMapping = [NSMutableDictionary dictionary];
        self.bundleCache = [NSMutableDictionary dictionary];
    }
    return self;
}

static NSNumber *themeTypeCache;
-(TRThemeType)themeType
{
    if (!themeTypeCache) {
        //从UserDefault中获取
        _themeType = [[NSUserDefaults standardUserDefaults] integerForKey:kTRThemeUserDefaultKey];
        themeTypeCache = @(_themeType);
    }
    return [themeTypeCache integerValue];
}

-(void)setThemeType:(TRThemeType)themeType
{
    themeTypeCache = @(themeType);
    if(_themeType != themeType){
        _themeType = themeType;
        //设置到UserDefault
        [[NSUserDefaults standardUserDefaults] setInteger:themeType forKey:kTRThemeUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //当前的文字颜色的对象
        themeCache = [TRTheme populateThemes:[self themeDictionaryFromBundle]];
        
        //发送主题改变的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kTRThemeChangeNofication object:[NSNumber numberWithInt:themeType]];
    }
}

static TRTheme *themeCache;
-(TRTheme *)theme
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        themeCache = [TRTheme populateThemes:[self themeDictionaryFromBundle]];
    });
    return themeCache;
}

//当前主题对应的bundle
-(NSBundle *)themeBundle
{
    NSString *bundlePath = [self bundlePath];
    if (bundlePath) {
        //从缓存中获取
        NSBundle *bundle = [self.bundleCache objectForKey:[self bundleIndentifier]];
        if (!bundle) {
            bundle = [NSBundle bundleWithPath:bundlePath];
            [self.bundleCache setObject:bundle forKey:[self bundleIndentifier]];
        }
        return bundle;
    }else{
        return [NSBundle mainBundle];
    }
}

//主题bundle的唯一标识
-(NSString *)bundleIndentifier
{
    return [themeBundleMapping objectForKey:[NSNumber numberWithInt:self.themeType]];
}

//bundle路径
-(NSString *)bundlePath
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *bundleIndentifier = [self bundleIndentifier];
    return [mainBundle pathForResource:bundleIndentifier ofType:@"bundle"];
}

//文字大小或颜色的plist
-(NSDictionary *)themeDictionaryFromBundle
{
    NSBundle *bundle = [self themeBundle];
    NSURL *plistUrl = [bundle URLForResource:@"theme" withExtension:@"plist"];
    NSDictionary *themeDic = [NSDictionary dictionaryWithContentsOfURL:plistUrl];
    if(themeDic){
        return themeDic;
    }else{
        return @{};
    }
}

@end
