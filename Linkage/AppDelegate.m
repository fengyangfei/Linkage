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


static NSString *const kStoreName = @"linkage.sqlite";

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupDataBase];
    
    [self umengTrack];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rooViewController;
    if (kNeedShowIntroduce) {
        rooViewController = [TutorialController shareViewController];
    }else{
        if ([LoginUser shareInstance]) {
            rooViewController = [[LATabBarController alloc]init];
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            rooViewController = [[UINavigationController alloc]initWithRootViewController:loginVC];
        }
    }
    self.window.rootViewController = rooViewController;
    
    [self.window makeKeyAndVisible];
    [self setupGlobalAppearance];
    
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
    [MobClick startWithAppkey:@"564d414567e58e62d1003c47" reportPolicy:BATCH channelId:@"web"];
    [MobClick updateOnlineConfig];  //在线参数配置
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
    
    //tabBar属性
    [UITabBar appearance].selectedImageTintColor = [UIColor paperColorBlue800];
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
}

@end
