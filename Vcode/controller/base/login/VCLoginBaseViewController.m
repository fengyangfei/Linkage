//
//  VCLoginBaseViewController.m
//  Linkage
//
//  Created by lihaijian on 2017/2/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCLoginBaseViewController.h"
#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"
#import "UIViewController+Extensions.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import <IQKeyboardManager/IQUITextFieldView+Additions.h>

#define kMarginWidth 20
#define SINGLE_LINE_WIDTH (2 / [UIScreen mainScreen].scale)

@interface VCLoginBaseViewController ()
@property (nonatomic, strong) UIView *logoImageView;

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) UIButton *dismissButton;
@end

@implementation VCLoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)setupUI
{
    /*
    {
        //背景图
        UIView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg"]];
        [self.view addSubview:backgroundView];
        [backgroundView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
     */
    self.view.backgroundColor = [UIColor whiteColor];
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
            make.top.equalTo(self.logoImageView.bottom).offset(42);
            make.height.equalTo(128);
        }];
        
        /*
        UIImageView *contentImageView = ({
            UIImage *inputBgImage = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(56, 8, 56, 8) resizingMode:UIImageResizingModeStretch];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:inputBgImage];
            imageView;
        });
        [allContentView addSubview:contentImageView];
        [contentImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(allContentView);
        }];
         */
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
        
        /*
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
        */
        
        [nameContentView addSubview:self.nameTextField];
        [self.nameTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameContentView.left);
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
        /*
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
         */
        
        [passwordContentView addSubview:self.passwordTextField];
        [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordContentView.left);
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
    {
        //注册按钮
        [self.view addSubview:self.registerButton];
        [self.registerButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(38);
            make.right.equalTo(self.view.centerX);
            make.top.equalTo(self.loginButton.bottom).offset(20);
            make.height.equalTo(@44);
        }];
        
        UIView *separateView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        [self.view addSubview:separateView];
        [separateView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.registerButton.centerY);
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(1);
            make.height.equalTo(18);
        }];
        
        //忘记密码
        [self.view addSubview:self.forgotPasswordButton];
        [self.forgotPasswordButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.centerX);
            make.right.equalTo(self.view.right).offset(-38);
            make.top.equalTo(self.loginButton.bottom).offset(20);
            make.height.equalTo(@44);
        }];
    }
    {
        //右上角X关闭按钮
        [self.view addSubview:self.dismissButton];
        [self.dismissButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.right).offset(-20);
            make.top.equalTo(self.view.top).offset(40);
            make.width.equalTo(50);
            make.height.equalTo(50);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 各种属性
-(UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.layer.masksToBounds = YES;
        _nameTextField.layer.cornerRadius = 25;
        _nameTextField.layer.borderWidth = 1.0;
        _nameTextField.layer.borderColor = IndexTitleFontColor.CGColor;
        //内边距
        _nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:VCThemeString(@"login_username_hint") attributes:@{NSForegroundColorAttributeName: IndexTitleFontColor}];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.textColor = IndexTitleFontColor;
        _nameTextField.keyboardDistanceFromTextField = 150.0;
    }
    return _nameTextField;
}

-(UITextField *)passwordTextField
{
    if(!_passwordTextField){
        _passwordTextField = [UITextField new];
        _passwordTextField.layer.masksToBounds = YES;
        _passwordTextField.layer.cornerRadius = 25;
        _passwordTextField.layer.borderWidth = 1.0;
        _passwordTextField.layer.borderColor = IndexTitleFontColor.CGColor;
        //内边距
        _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:VCThemeString(@"login_password") attributes:@{NSForegroundColorAttributeName: IndexTitleFontColor}];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.textColor = IndexTitleFontColor;
        _passwordTextField.keyboardDistanceFromTextField = 150.0 - 44.0;
    }
    return _passwordTextField;
}

-(UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = ({
            BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
            button.cornerRadius = 25;
            NSAttributedString *title = [[NSAttributedString alloc]initWithString:VCThemeString(@"login") attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
            [button setAttributedTitle:title forState:UIControlStateNormal];
            [button setBackgroundColor:VHeaderColor];
            button;
        });
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = ({
            UILabel *view = [UILabel new];
            view.numberOfLines = 0;
            view.textColor = IndexTitleFontColor;
            view.textAlignment = NSTextAlignmentCenter;
            view.font = [UIFont systemFontOfSize:22];
            view.text = VCThemeString(@"login_text");
            view;
        });
    }
    return _logoImageView;
}

-(UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:VCThemeString(@"login_regisrer") attributes:@{NSForegroundColorAttributeName:IndexTitleFontColor,NSFontAttributeName:[UIFont systemFontOfSize:16],NSUnderlineStyleAttributeName:@1}];
        [_registerButton setAttributedTitle:title forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _registerButton;
}

-(UIButton *)forgotPasswordButton
{
    if (!_forgotPasswordButton) {
        _forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:VCThemeString(@"login_wjmm") attributes:@{NSForegroundColorAttributeName:IndexTitleFontColor,NSFontAttributeName:[UIFont systemFontOfSize:16],NSUnderlineStyleAttributeName:@1}];
        [_forgotPasswordButton setAttributedTitle:title forState:UIControlStateNormal];
        [_forgotPasswordButton addTarget:self action:@selector(forgotPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
        _forgotPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _forgotPasswordButton;
}

-(UIButton *)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
        [_dismissButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _dismissButton;
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

-(void)dismissAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
