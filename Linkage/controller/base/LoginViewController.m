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
#import "YGRestClient.h"
#import "LoginUser.h"
#import "Company.h"
#import "CocoaSecurity.h"
#import "CompanyUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface LoginViewController ()

@end

@implementation LoginViewController


#pragma mark - 事件
-(void)loginAction:(id)sender
{
    WeakSelf
    NSString *userName = self.nameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSDictionary *paramter = @{
                               @"mobile":userName,
                               @"password":[password md5]
                               };
    [[YGRestClient sharedInstance] postForObjectWithUrl:LoginUrl form:paramter success:^(id responseObject) {
        NSError *error = nil;
        LoginUser *loginUser = [MTLJSONAdapter modelOfClass:[LoginUser class] fromJSONDictionary:responseObject error:&error];
        if (loginUser && !error) {
            [loginUser save];
            //主题变更
            if (loginUser.ctype == UserTypeCompanyAdmin) {
                [TRThemeManager shareInstance].themeType = TRThemeTypeCompany;
            }else if (loginUser.ctype == UserTypeSubCompanyAdmin){
                [TRThemeManager shareInstance].themeType = TRThemeTypeSubCompany;
            }
            //获取企业信息
            [CompanyUtil queryModelFromServer:^(Company *model) {
                [model save];
            }];
            
            LATabBarController *tabBarController = [[LATabBarController alloc]init];
            [weakSelf presentViewController:tabBarController animated:YES completion:nil];
        }else{
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@" ,error]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
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
