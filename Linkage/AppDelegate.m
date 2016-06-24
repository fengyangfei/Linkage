//
//  AppDelegate.m
//  Linkage
//
//  Created by lihaijian on 16/2/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AppDelegate.h"
#import "TutorialController.h"
#import "LATabBarController.h"
#import "UIColor+BFPaperColors.h"
#import "MobClick.h"
#import "UIImage+ImageWithColor.h"
#import "LoginUser.h"
#import "LoginViewController.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import <XLFormViewController.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialYixinHandler.h"

static NSString *const kStoreName = @"linkage.sqlite";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppKey];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    [self setupDataBase];
    
    [self umengTrack];
    [self setupSocialConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rooViewController;
    if (kNeedShowIntroduce) {
        rooViewController = [TutorialController shareViewController];
    }else{
        if ([LoginUser shareInstance]) {
            rooViewController = [[LATabBarController alloc]init];
        }else{
            rooViewController = [[LoginViewController alloc]init];
        }
    }
    self.window.rootViewController = rooViewController;
    
    [self.window makeKeyAndVisible];
    [self setupGlobalAppearance];
    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[XLFormViewController class]];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [TRThemeManager shareInstance].themeType = TRThemeTypeCompany;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupGlobalAppearance) name:kTRThemeChangeNofication object:nil];
    
    return YES;
}

/*
 * 初始化数据库
 */
-(void)setupDataBase
{
    NSLog(@"数据库路径-%@", [self applicationDocumentsDirectory]);
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kStoreName];
}

/*
 * 数据库路径
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:kUmengSocialAppKey reportPolicy:BATCH channelId:@"web"];
    [MobClick updateOnlineConfig];  //在线参数配置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

/**
 *  设置社交App的Key
 */
-(void)setupSocialConfig
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUmengSocialAppKey];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:kAppIndexHtml];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppkey url:kAppIndexHtml];
    
    //设置易信Appkey和分享url地址,注意需要引用头文件 #import UMSocialYixinHandler.h
    [UMSocialYixinHandler setYixinAppKey:kYixinAppkey url:kAppIndexHtml];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = kSocialTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = kSocialTitle;
    [UMSocialData defaultData].extConfig.wechatFavoriteData.title = kSocialTitle;
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    NSDictionary *onlineDic = note.userInfo;
    if (onlineDic && [onlineDic[@"available"] isEqualToString:@"0"]) {
        UIViewController *rooViewController = [[UIViewController alloc]init];
        self.window.rootViewController = rooViewController;
        [self.window makeKeyAndVisible];
    }
}

- (void)setupGlobalAppearance
{
    //设置导航标题属性
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = HeaderColor;
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil];
    [UINavigationBar appearance].translucent = NO;
    UIImage *image = [UIImage imageWithColor:HeaderColor];
    [[UINavigationBar appearance] setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    //设置tabBar属性
    [[UITabBar appearance] setSelectedImageTintColor:HeaderColor];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UMOnlineConfigDidFinishedNotification object:nil];
}

@end
