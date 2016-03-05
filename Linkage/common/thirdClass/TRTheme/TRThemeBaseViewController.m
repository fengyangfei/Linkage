//
//  TRThemeBaseViewController.m
//  YGTravel
//
//  Created by Mac mini on 16/1/11.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "TRThemeBaseViewController.h"
#import "TRThemeManager.h"
#import "UIViewController+TRTheme.h"

@implementation TRThemeBaseViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTheme];
    //注册主题改变事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(configureTheme) name:kTRThemeChangeNofication object:nil];
}

//处理主题变化的通知方法
-(void)configureTheme
{
    BOOL hasChange = [self isThemeHasChange];
    [self themeDidChange:hasChange];
}

-(void)themeDidChange:(BOOL)hasChange
{
    if (hasChange) {
        [self setupTheme];
    }
}

@end
