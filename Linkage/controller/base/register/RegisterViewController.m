//
//  RegisterViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "RegisterViewController.h"
#import "YGRestClient.h"
#import "FormTextFieldAndButtonCell.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phoneNum" rowType:XLFormRowDescriptorTypeText title:@"手机"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"inviteCode" rowType:XLFormRowDescriptorTypePassword title:@"验证码"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"againPassword" rowType:XLFormRowDescriptorTypePassword title:@"确认密码"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"注册"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf registerAction];
    };
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"生成验证码"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf genInviteCode];
    };
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)registerAction
{
    NSDictionary *formValues = [self.form formValues];
    NSDictionary *paramter = @{@"mobile":formValues[@"phoneNum"],
                               @"password":formValues[@"password"],
                               @"ctype":@0,
                               @"invite_code":formValues[@"inviteCode"]};
    [[YGRestClient sharedInstance] postForObjectWithUrl:Register4InviteUrl form:paramter success:^(id responseObject) {
        NSLog(@"sucss%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)genInviteCode
{
    NSDictionary *formValues = [self.form formValues];
    NSDictionary *paramter = @{@"mobile":formValues[@"phoneNum"]};
    [[YGRestClient sharedInstance] postForObjectWithUrl:VerifycodeUrl form:paramter success:^(id responseObject) {
        NSLog(@"sucss%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end