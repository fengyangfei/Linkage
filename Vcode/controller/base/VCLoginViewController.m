//
//  VCLoginViewController.m
//  Linkage
//
//  Created by lihaijian on 2017/2/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCLoginViewController.h"
#import "VCRegisterViewController.h"

@interface VCLoginViewController ()

@end

@implementation VCLoginViewController


#pragma mark - 事件
-(void)loginAction:(id)sender
{
   
}

-(void)forgotPasswordAction:(id)sender
{
    UIViewController *viewController = [[UIViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)registerAction:(id)sender
{
    VCRegisterViewController *registerViewController = [[VCRegisterViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:registerViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
