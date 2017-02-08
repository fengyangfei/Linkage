//
//  UINavigationController+LoginFilter.m
//  Linkage
//
//  Created by lihaijian on 2017/2/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "UINavigationController+LoginFilter.h"
#import "VCLoginUser.h"
#import "VCLoginViewController.h"
#import "VCPersonalViewController.h"
#import <objc/runtime.h>

static inline void af_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@implementation UINavigationController (LoginFilter)

+(void)load
{
    af_swizzleSelector(self, @selector(pushViewController:animated:), @selector(login_pushViewController:animated:));
}

- (void)login_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    //如果用户没登录，则跳去登录页
    //“个人信息”、“V币账户”和“云同步”时，如果用户未登录，调整到登陆页面
    if ([viewController isKindOfClass:[VCPersonalViewController class]] && ![VCLoginUser loginUserInstance]) {
        VCLoginViewController *loginVC = [[VCLoginViewController alloc]init];
        //UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
    }else{
        [self login_pushViewController:viewController animated:animated];
    }
}

@end
