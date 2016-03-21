//
//  LoginViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LoginViewController.h"
#import "LATabBarController.h"
#import "RegisterViewController.h"
#import "ForgotPasswordController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


#pragma mark - 事件
-(void)loginAction:(id)sender
{
    LATabBarController *tabBarController = [[LATabBarController alloc]init];
    [self presentViewController:tabBarController animated:YES completion:nil];
}

-(void)forgotPasswordAction:(id)sender
{
    ForgotPasswordController *viewController = [[ForgotPasswordController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)registerAction:(id)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:registerViewController];
    [self presentViewController:navController animated:YES completion:nil];

}

@end
