//
//  ForgotPasswordController.m
//  Linkage
//
//  Created by lihaijian on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "ForgotPasswordController.h"
#import "BFPaperButton.h"
#import "FormTextFieldAndButtonCell.h"
#import "CocoaSecurity.h"
#import "YGRestClient.h"
#import "TimerManager.h"
#import "XLFormValidator+Regex.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ForgotPasswordController ()

@end

@implementation ForgotPasswordController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phoneNum" rowType:XLFormRowDescriptorTypeText title:@"手机号"];
    [row addValidator:[XLFormValidator phoneNumValidator]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"newpassword" rowType:XLFormRowDescriptorTypePassword title:@"新密码"];
    row.required = YES;
    [row addValidator:[XLFormValidator passswordValidator]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"confirmPassword" rowType:XLFormRowDescriptorTypePassword title:@"确认密码"];
    row.required = YES;
    [row addValidator:[XLFormValidator passswordValidator]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"verifyCode" rowType:XLFormRowDescriptorTypeTextAndButton title:@"验证码"];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-54);
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.tableView.bottom);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    BFPaperButton *button = ({
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
        button.cornerRadius = 4;
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:ButtonDisableBgImage forState:UIControlStateDisabled];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"提 交" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [bottomView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.left).offset(10);
        make.right.equalTo(bottomView.right).offset(-10);
        make.top.equalTo(bottomView.top).offset(5);
        make.height.equalTo(@44);
    }];
}

-(void)backAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)forgetAction:(id)row
{
    WeakSelf
    [self.tableView endEditing:YES];
    
    NSDictionary *formValues = [self.form formValues];
    NSArray *errors = [self formValidationErrors];
    if (errors && errors.count > 0) {
        NSError *error = [errors firstObject];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if(![formValues[@"newpassword"] isEqualToString:formValues[@"confirmPassword"]]){
        [SVProgressHUD showErrorWithStatus:@"两次填入密码不一致"];
        return;
    }
    
    NSDictionary *paramter = @{@"mobile":NilStringWrapper(formValues[@"phoneNum"]),
                               @"password":[NilStringWrapper(formValues[@"newpassword"]) md5],
                               @"verify_code":NilStringWrapper(formValues[@"verifyCode"])};
    [[YGRestClient sharedInstance] postForObjectWithUrl:ForgotPasswordUrl form:paramter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

-(void)generateVerifyCode:(XLFormRowDescriptor *)row
{
    NSDictionary *formValues = [self.form formValues];
    NSString *photoNum = NilStringWrapper(formValues[@"phoneNum"]);
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneNumRegex];
    BOOL isMatch = [pred evaluateWithObject:photoNum];
    if (!isMatch) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号码"];
        return;
    }
    
    //正在倒计时，不再请求验证码
    if ([TimerManager shareInstance].isValid) {
        return;
    }
    
    FormTextFieldAndButtonCell *cell = (FormTextFieldAndButtonCell *)[row cellForFormController:nil];
    __weak FormTextFieldAndButtonCell *weakCell = cell;
    [TimerManager shareInstance].block = ^(NSInteger second){
        if (second > 0) {
            NSString *title = [NSString stringWithFormat:@"(%ld)后重新获取", (long)second];
            [weakCell.button setTitle:title forState:UIControlStateNormal];
        }else{
            [weakCell.button setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    };
    NSDictionary *paramter = @{@"mobile": photoNum};
    [[YGRestClient sharedInstance] postForObjectWithUrl:VerifycodeUrl form:paramter success:^(id responseObject) {
        [[TimerManager shareInstance] fire];
    } failure:^(NSError *error) {
        
    }];
}

@end
