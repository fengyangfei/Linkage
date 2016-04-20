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
#import <SVProgressHUD/SVProgressHUD.h>

@interface RegisterViewController ()
@property (nonatomic, strong) UISegmentedControl *segementedControl;
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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"companyName" rowType:XLFormRowDescriptorTypeText title:@"公司名称"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText title:@"注册人姓名"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"gender" rowType:XLFormRowDescriptorTypeSelectorPush title:@"性别"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"女"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"男"]
                            ];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phoneNum" rowType:XLFormRowDescriptorTypeText title:@"手机"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"verifyCode" rowType:XLFormRowDescriptorTypeTextAndButton title:@"验证码"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf generateVerifyCode:sender];
    };
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"againPassword" rowType:XLFormRowDescriptorTypePassword title:@"确认密码"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"register" rowType:XLFormRowDescriptorTypeButton title:@"注册"];
    //row.disabled = @YES;
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf registerAction:sender];
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
    self.navigationItem.titleView = self.segementedControl;
}

-(UISegmentedControl *)segementedControl
{
    if (!_segementedControl) {
        _segementedControl = [[UISegmentedControl alloc]initWithItems:@[@"厂商",@"承运商"]];
        _segementedControl.selectedSegmentIndex = 0;
    }
    return _segementedControl;
}

-(void)backAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerAction:(XLFormRowDescriptor *)row
{
    WeakSelf
    [self deselectFormRow:row];
    [self.tableView endEditing:YES];
    NSDictionary *formValues = [self.form formValues];
    NSDictionary *paramter = @{@"mobile":NilStringWrapper(formValues[@"phoneNum"]),
                               @"password":NilStringWrapper(formValues[@"password"]),
                               @"company_name":NilStringWrapper(formValues[@"companyName"]),
                               @"ctype":@(self.segementedControl.selectedSegmentIndex),
                               @"verify_code":NilStringWrapper(formValues[@"verifyCode"])};
    [[YGRestClient sharedInstance] postForObjectWithUrl:Register4AdminUrl form:paramter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
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
            NSString *title = [NSString stringWithFormat:@"(%ld)秒后重新获取", (long)second];
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

#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
