//
//  VCTabBarController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCTabBarController.h"
#import "UIColor+BFPaperColors.h"
#import "VCHotViewController.h"
#import "VCFavorViewController.h"
#import "VCMineViewController.h"
#import "VCRankViewController.h"

@interface VCTabBarController ()

@end

@implementation VCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setupUI
{
    UIViewController *mainViewController = ({
        NSString *title = @"推荐";
        VCHotViewController *viewController = [[VCHotViewController alloc] init];
        viewController.view.backgroundColor = [UIColor paperColorCyan400];
        viewController.title = title;
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"hot"] selectedImage:[UIImage imageNamed:@"hot_on"]];
        viewController;
    });
    
    UIViewController *billController = ({
        NSString *title = @"收藏";
        VCFavorViewController *viewController = [[VCFavorViewController alloc]init];
        viewController.title = title;
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"love"] selectedImage:[UIImage imageNamed:@"love_on"]];
        viewController;
    });
    
    UIViewController *messageController = ({
        NSString *title = @"排行";
        VCRankViewController *viewController = [[VCRankViewController alloc]init];
        viewController.title = title;
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"ranking"] selectedImage:[UIImage imageNamed:@"ranking_on"]];
        viewController.tabBarItem = item;
        viewController;
    });
    
    UIViewController *mineController = ({
        NSString *title = @"我的";
        VCMineViewController *viewController = [[VCMineViewController alloc]init];
        viewController.title = title;
        viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:@"user_on"] selectedImage:[UIImage imageNamed:@"user"]];
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
