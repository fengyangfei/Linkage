//
//  VCRegisterViewController.m
//  Linkage
//
//  Created by lihaijian on 2017/2/8.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCRegisterViewController.h"
#import "YGRestClient.h"
#import "FormTextFieldAndButtonCell.h"
#import "TimerManager.h"
#import "LinkUtil.h"
#import "CocoaSecurity.h"
#import "BFPaperButton.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface VCRegisterViewController ()
@property (nonatomic, strong) UISegmentedControl *segementedControl;
@end

@implementation VCRegisterViewController

-(void)dealloc
{
    [[TimerManager shareInstance] invalidate];
}

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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phoneNum" rowType:XLFormRowDescriptorTypeText title:VCThemeString(@"regisrer_phone")];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"verifyCode" rowType:XLFormRowDescriptorTypeTextAndButton title:VCThemeString(@"regisrer_code")];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf generateVerifyCode:sender];
    };
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword title:VCThemeString(@"regisrer_password")];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"confirmPassword" rowType:XLFormRowDescriptorTypePassword title:VCThemeString(@"regisrer_password_again")];
    row.required = YES;
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VCThemeString(@"regisrer");
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-54);
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
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
        [button setBackgroundColor:VHeaderColor];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:VCThemeString(@"regisrer") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)registerAction:(id)row
{
    WeakSelf
    [self.tableView endEditing:YES];
    NSDictionary *formValues = [self.form formValues];
    NSArray *errors = [self formValidationErrors];
    if (errors && errors.count > 0) {
        [self showFormValidationError:errors[0]];
        return;
    }
    
    if(![formValues[@"password"] isEqualToString:formValues[@"confirmPassword"]]){
        [SVProgressHUD showErrorWithStatus:VCThemeString(@"regisrer_passwordnotoo")];
        return;
    }
    
    NSDictionary *paramter = @{@"mobile":NilStringWrapper(formValues[@"phoneNum"]),
                               @"password":[NilStringWrapper(formValues[@"password"]) md5],
                               @"company_name":NilStringWrapper(formValues[@"companyName"]),
                               @"name":NilStringWrapper(formValues[@"name"]),
                               @"gender":[formValues[@"name"] valueData],
                               @"ctype":[formValues[@"ctype"] valueData],
                               @"verify_code":NilStringWrapper(formValues[@"verifyCode"])};
    [[YGRestClient sharedInstance] postForObjectWithUrl:Register4AdminUrl form:paramter success:^(id responseObject) {
        //注册成功
        [SVProgressHUD showSuccessWithStatus:VCThemeString(@"regisrer_ok")];
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
        //输入手机号不合法
        [SVProgressHUD showErrorWithStatus:VCThemeString(@"regisrer_phone_no")];
        return;
    }
    
    //正在倒计时，不再请求验证码
    if ([TimerManager shareInstance].isValid) {
        return;
    }
    
    NSDictionary *paramter = @{@"mobile": photoNum};
    [[YGRestClient sharedInstance] postForObjectWithUrl:VerifycodeUrl form:paramter success:^(id responseObject) {
        [[TimerManager shareInstance] fire];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
