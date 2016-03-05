//
//  LoginBaseViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/24.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LoginBaseViewController.h"
#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"
#import "UIViewController+Extensions.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import <IQKeyboardManager/IQUITextFieldView+Additions.h>


#define kMarginWidth 20
#define SINGLE_LINE_WIDTH (2 / [UIScreen mainScreen].scale)

@interface LoginBaseViewController ()
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@end

@implementation LoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *allContentView = [UIView new];
    
    UIView *lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor paperColorGray];
        view;
    });
    
    UIView *lineView1 = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor paperColorGray];
        view;
    });
    
    {
        [self.view addSubview:self.logoImageView];
        [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.top.equalTo(self.view.top).offset(100);
            make.width.equalTo(@150);
            make.height.equalTo(@150);
        }];
        
        UILabel *titleLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:22];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"Link APP";
            label;
        });
        [self.view addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.top.equalTo(self.logoImageView.bottom).offset(5);
        }];
        
        [self.view addSubview:allContentView];
        [allContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
            make.top.equalTo(titleLabel.bottom).offset(20);
            make.height.equalTo(300);
        }];
    }
    {
        //账号列
        UIView *nameContentView = [UIView new];
        [allContentView addSubview:nameContentView];
        [nameContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allContentView.left);
            make.right.equalTo(allContentView.right);
            make.top.equalTo(allContentView.top);
            make.height.equalTo(44);
        }];
        
        UILabel *nameLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"账号";
            label;
        });
        [nameContentView addSubview:nameLabel];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameContentView.left).offset(kMarginWidth);
            make.width.equalTo(50);
            make.top.equalTo(nameContentView.top);
            make.bottom.equalTo(nameContentView.bottom);
        }];
        
        [nameContentView addSubview:self.nameTextField];
        [self.nameTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.right);
            make.right.equalTo(nameContentView.right);
            make.top.equalTo(nameContentView.top);
            make.bottom.equalTo(nameContentView.bottom);
        }];
        
        [allContentView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allContentView.left).offset(kMarginWidth);
            make.right.equalTo(allContentView.right);
            make.top.equalTo(nameContentView.bottom);
            make.height.equalTo(SINGLE_LINE_WIDTH);
        }];
    }
    {
        //密码列
        UIView *passwordContentView = [UIView new];
        [allContentView addSubview:passwordContentView];
        [passwordContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allContentView.left);
            make.right.equalTo(allContentView.right);
            make.top.equalTo(lineView.bottom);
            make.height.equalTo(44);
        }];
        
        UILabel *passwordLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"密码";
            label;
        });
        [passwordContentView addSubview:passwordLabel];
        [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordContentView.left).offset(kMarginWidth);
            make.width.equalTo(50);
            make.top.equalTo(passwordContentView.top);
            make.bottom.equalTo(passwordContentView.bottom);
        }];
        
        [passwordContentView addSubview:self.passwordTextField];
        [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordLabel.right);
            make.right.equalTo(passwordContentView.right);
            make.top.equalTo(passwordContentView.top);
            make.bottom.equalTo(passwordContentView.bottom);
        }];
        
        [allContentView addSubview:lineView1];
        [lineView1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allContentView.left).offset(kMarginWidth);
            make.right.equalTo(allContentView.right);
            make.top.equalTo(passwordContentView.bottom);
            make.height.equalTo(SINGLE_LINE_WIDTH);
        }];
    }
    {
        //登录按钮
        [allContentView addSubview:self.loginButton];
        [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allContentView.left).offset(kMarginWidth);
            make.right.equalTo(allContentView.right).offset(-kMarginWidth);
            make.top.equalTo(lineView1.bottom).offset(25);
            make.height.equalTo(48);
        }];
    }
    [self.view addSubview:self.registerButton];
    [self.registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(-20);
        make.height.equalTo(@44);
    }];
    
    [self.view addSubview:self.forgotPasswordButton];
    [self.forgotPasswordButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-20);
        make.height.equalTo(@44);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 各种属性
-(UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.placeholder = @"请输入用户名";
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.keyboardDistanceFromTextField = 150.0;
    }
    return _nameTextField;
}

-(UITextField *)passwordTextField
{
    if(!_passwordTextField){
        _passwordTextField = [UITextField new];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.keyboardDistanceFromTextField = 150.0 - 44.0;

    }
    return _passwordTextField;
}

-(UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = ({
            BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
            button.cornerRadius = 6;
            [button setBackgroundColor:[UIColor paperColorBlue]];
            [button setTitle:@"登录" forState:UIControlStateNormal];
            button;
        });
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIImageView *)logoImageView
{
    if (!_logoImageView) {
        UIImage *logoImage = [UIImage imageNamed:@"logo"];
        _logoImageView = [[UIImageView alloc]initWithImage:logoImage];
    }
    return _logoImageView;
}

-(UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"用户注册" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16], NSUnderlineStyleAttributeName:@1}];
        [_registerButton setAttributedTitle:title forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(UIButton *)forgotPasswordButton
{
    if (!_forgotPasswordButton) {
        _forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"忘记密码" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16],NSUnderlineStyleAttributeName:@1}];
        [_forgotPasswordButton setAttributedTitle:title forState:UIControlStateNormal];
        [_forgotPasswordButton addTarget:self action:@selector(forgotPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordButton;
}

-(void)loginAction:(id)sender
{
}

-(void)forgotPasswordAction:(id)sender
{

}

-(void)registerAction:(id)sender
{
    
}

@end
