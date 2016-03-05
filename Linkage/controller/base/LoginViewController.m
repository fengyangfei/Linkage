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
    [self.navigationController pushViewController:tabBarController animated:YES];
}

-(void)forgotPasswordAction:(id)sender
{
    ForgotPasswordController *viewController = [[ForgotPasswordController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];

}

-(void)registerAction:(id)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

@end
