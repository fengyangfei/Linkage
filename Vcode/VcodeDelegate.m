//
//  AppDelegate.m
//  Linkage
//
//  Created by lihaijian on 16/2/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "VcodeDelegate.h"
#import "VCTutorialController.h"
#import "VCTabBarController.h"
#import "UIColor+BFPaperColors.h"
#import "MobClick.h"
#import "UIImage+ImageWithColor.h"
#import "LoginUser.h"
#import "LoginViewController.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import <XLFormViewController.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialYixinHandler.h"


static NSString *const kVcodeStoreName = @"vcode.sqlite";

@interface VcodeDelegate ()

@end

@implementation VcodeDelegate
{
    UINavigationController *_navController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppKey];
//    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    [self setupDataBase];
//    [self registerJPushWithOptions:launchOptions];
    
//    [self umengTrack];
//    [self setupSocialConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rooViewController;
    if (kNeedShowIntroduce) {
        rooViewController = [VCTutorialController shareViewController];
    }else{
        rooViewController = [[VCTabBarController alloc]init];
    }
    self.window.rootViewController = rooViewController;
    
    [self.window makeKeyAndVisible];
    [self setupGlobalAppearance];
    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[XLFormViewController class]];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupGlobalAppearance) name:kTRThemeChangeNofication object:nil];
    
    return YES;
}

/*
 * 初始化数据库
 */
-(void)setupDataBase
{
    NSLog(@"数据库路径-%@", [self applicationDocumentsDirectory]);
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kVcodeStoreName];
}

/*
 * 数据库路径
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/*
 * 注册极光推送
 */
-(void)registerJPushWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    //不需要用到advertisingIndentifier
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:@"web"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //设置tags和alias
    if([LoginUser shareInstance]){
        NSSet *tags = [[NSSet alloc]initWithArray:@[@"web",@"test",@"message"]];
        [JPUSHService setTags:tags aliasInbackground:[LoginUser shareInstance].cid];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

//友盟sdk
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
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil];
    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    //设置tabBar属性
    [[UITabBar appearance] setSelectedImageTintColor:VHeaderColor];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UMOnlineConfigDidFinishedNotification object:nil];
}

#pragma mark - 帮助类

-(void)backAction:(id)sender
{
    if(_navController){
        [_navController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
