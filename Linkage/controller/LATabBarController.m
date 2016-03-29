//
//  LATabBarController.m
//  Linkage
//
//  Created by Mac mini on 16/2/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LATabBarController.h"
#import "UIColor+BFPaperColors.h"
#import "MainViewController.h"
#import "BillViewController.h"
#import "MineViewController.h"
#import "MessageViewController.h"

@interface LATabBarController ()

@end

@implementation LATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setupUI
{
    MainViewController *mainViewController = ({
        NSString *title = @"首页";
        MainViewController *viewController = [[MainViewController alloc] init];
        viewController.view.backgroundColor = [UIColor paperColorCyan400];
        viewController.title = title;
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"icon_tab_shouye_normal"] selectedImage:[UIImage imageNamed:@"icon_tab_shouye_normal_light"]];
        viewController;
    });
    
    UIViewController *billController = ({
        NSString *title = @"订单";
        BillViewController *viewController = [[BillViewController alloc]init];
        viewController.title = title;
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"tab_icon_selection_normal"] selectedImage:[UIImage imageNamed:@"tab_icon_selection_normal_light"]];
        viewController;
    });
    
    UIViewController *messageController = ({
        NSString *title = @"消息";
        MessageViewController *viewController = [[MessageViewController alloc]init];
        viewController.title = title;
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"icon_tab_fujin_normal"] selectedImage:[UIImage imageNamed:@"icon_tab_fujin_normal_light"]];
        viewController;
    });
    
    UIViewController *mineController = ({
        NSString *title = @"我的";
        MineViewController *viewController = [[MineViewController alloc]init];
        viewController.title = title;
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"icon_tab_wode_normal"] selectedImage:[UIImage imageNamed:@"icon_tab_wode_normal_light"]];
        viewController;
    });
    
    self.viewControllers = @[
                             [[UINavigationController alloc]initWithRootViewController:mainViewController],
                             [[UINavigationController alloc]initWithRootViewController:billController],
                             [[UINavigationController alloc]initWithRootViewController:messageController],
                             [[UINavigationController alloc]initWithRootViewController:mineController]
                             ];
    
    self.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
