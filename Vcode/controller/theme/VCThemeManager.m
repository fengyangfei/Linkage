//
//  VCThemeManager.m
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCThemeManager.h"

NSString *const kVCThemeChangeNofication = @"com.ygsoft.vcode.theme.change";
NSString *const kVCThemeUserDefaultKey = @"com.ygsoft.vcode.theme.current";

@interface VCThemeManager()
@property (nonatomic, strong) NSMutableDictionary *bundleCache;
@end

@implementation VCThemeManager
@synthesize themeType = _themeType;

static NSDictionary *themeBundleMapping;
+(void)load
{
    themeBundleMapping = @{
                           [NSNumber numberWithInt:VCThemeTypeCN] : @"VCThemeTypeCN",
                           [NSNumber numberWithInt:VCThemeTypeEN] :@"VCThemeTypeEN"
                           };
}

+(VCThemeManager *)shareInstance
{
    static VCThemeManager *manager;
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
-(VCThemeType)themeType
{
    if (!themeTypeCache) {
        //从UserDefault中获取
        _themeType = [[NSUserDefaults standardUserDefaults] integerForKey:kVCThemeUserDefaultKey];
        themeTypeCache = @(_themeType);
    }
    return [themeTypeCache integerValue];
}

-(void)setThemeType:(VCThemeType)themeType
{
    themeTypeCache = @(themeType);
    if(_themeType != themeType){
        _themeType = themeType;
        //设置到UserDefault
        [[NSUserDefaults standardUserDefaults] setInteger:themeType forKey:kVCThemeUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //发送主题改变的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kVCThemeChangeNofication object:[NSNumber numberWithInt:themeType]];
    }
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

@end
