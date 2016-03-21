//
//  PersonalSettingController.m
//  Linkage
//
//  Created by lihaijian on 16/3/3.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "PersonalSettingController.h"
#import "LoginViewController.h"

@interface PersonalSettingController ()

@end

@implementation PersonalSettingController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)initializeForm
{
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"个人设置"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"avart" rowType:XLFormRowDescriptorTypeText title:@"我的头像"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"userName" rowType:XLFormRowDescriptorTypeText title:@"姓名"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"sex" rowType:XLFormRowDescriptorTypeSelectorPush title:@"性别"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"男"];
    row.selectorTitle = @"性别";
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"女"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"男"]
                            ];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phoneNum" rowType:XLFormRowDescriptorTypeText title:@"手机"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeEmail title:@"邮箱"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"changePassword" rowType:XLFormRowDescriptorTypeButton title:@"密码修改"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"logout" rowType:XLFormRowDescriptorTypeButton title:@"退出"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf logoutAction];
    };
    [section addFormRow:row];
    
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionHeaderHeight = 0.0f;
    self.tableView.sectionFooterHeight = 10.0f;
}

//退出
-(void)logoutAction
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
}


@end
