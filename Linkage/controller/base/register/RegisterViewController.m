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
#import "TimerManager.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phoneNum" rowType:XLFormRowDescriptorTypeTextAndButton title:@"手机"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf genInviteCode];
    };
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
    row.disabled = @YES;
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf registerAction];
    };
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
}

-(void)backAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerAction
{
    [self.tableView endEditing:YES];
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
    NSLog(@"生成验证码");
    NSDictionary *formValues = [self.form formValues];
    NSDictionary *paramter = @{@"mobile":formValues[@"phoneNum"]};
    [[YGRestClient sharedInstance] postForObjectWithUrl:VerifycodeUrl form:paramter success:^(id responseObject) {
        NSLog(@"sucss%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
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
