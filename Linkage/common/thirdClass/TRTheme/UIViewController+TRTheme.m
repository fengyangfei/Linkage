//
//  UIViewController+TRTheme.m
//  YGTravel
//
//  Created by Mac mini on 16/1/29.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "UIViewController+TRTheme.h"

@implementation UIViewController (TRTheme)

//对比之前的viewController是否有改变
-(BOOL)isThemeHasChange
{
    NSNumber *theme = [[TRThemeManager shareInstance].viewControllerThemeMapping objectForKey:NSStringFromClass([self class])];
    if ([theme intValue] != [TRThemeManager shareInstance].themeType) {
        //有变化
        return YES;
    }else{
        //无变化
        return NO;
    }
}

//设置当前ViewController对应的主题
-(void)setupTheme
{
    [[TRThemeManager shareInstance].viewControllerThemeMapping setObject:@([TRThemeManager shareInstance].themeType) forKey:NSStringFromClass([self class])];
}
@end
