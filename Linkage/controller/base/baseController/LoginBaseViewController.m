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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)setupUI
{
    {
        //背景图
        UIView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
        [self.view addSubview:backgroundView];
        [backgroundView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    UIView *allContentView = [[UIView alloc]init];
    {
        [self.view addSubview:self.logoImageView];
        [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.top.equalTo(self.view.top).offset(100);
        }];
        
        [self.view addSubview:allContentView];
        [allContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(38);
            make.right.equalTo(self.view.right).offset(-38);
            make.top.equalTo(self.logoImageView.bottom).offset(82);
            make.height.equalTo(108);
        }];
        
        UIImageView *contentImageView = ({
            UIImage *inputBgImage = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(56, 8, 56, 8) resizingMode:UIImageResizingModeStretch];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:inputBgImage];
            imageView;
        });
        [allContentView addSubview:contentImageView];
        [contentImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(allContentView);
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
            make.height.equalTo(54);
        }];
        
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_icon"]];
            imageView;
        });
        [nameContentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameContentView.left).offset(16);
            make.centerY.equalTo(nameContentView.centerY);
            make.width.equalTo(14);
            make.height.equalTo(17);
        }];
        
        UILabel *nameLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.text = @"账号";
            label;
        });
        [nameContentView addSubview:nameLabel];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.right).offset(16);
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
    }
    {
        //密码列
        UIView *passwordContentView = [UIView new];
        [allContentView addSubview:passwordContentView];
        [passwordContentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allContentView.left);
            make.right.equalTo(allContentView.right);
            make.bottom.equalTo(allContentView.bottom);
            make.height.equalTo(54);
        }];
        
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_icon"]];
            imageView;
        });
        [passwordContentView addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordContentView.left).offset(16);
            make.centerY.equalTo(passwordContentView.centerY);
            make.width.equalTo(14);
            make.height.equalTo(17);
        }];
        
        UILabel *passwordLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.text = @"密码";
            label;
        });
        [passwordContentView addSubview:passwordLabel];
        [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.right).offset(16);
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
    }
    {
        //登录按钮
        [self.view addSubview:self.loginButton];
        [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allContentView.left);
            make.right.equalTo(allContentView.right);
            make.top.equalTo(allContentView.bottom).offset(20);
            make.height.equalTo(50);
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
        _nameTextField.textColor = [UIColor whiteColor];
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
        _passwordTextField.textColor = [UIColor whiteColor];
        _passwordTextField.keyboardDistanceFromTextField = 150.0 - 44.0;

    }
    return _passwordTextField;
}

-(UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = ({
            BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
            button.cornerRadius = 10;
            [button setTitle:@"登录" forState:UIControlStateNormal];
            UIImage *image =[[UIImage imageNamed:@"btn_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 11, 25, 11) resizingMode:UIImageResizingModeStretch];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setBackgroundImage:image forState:UIControlStateHighlighted];
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
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"用户注册 ?" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [_registerButton setAttributedTitle:title forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

-(UIButton *)forgotPasswordButton
{
    if (!_forgotPasswordButton) {
        _forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"忘记密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
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
