//
//  PersonalSettingController.m
//  Linkage
//
//  Created by lihaijian on 16/3/3.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "PersonalSettingController.h"
#import "LoginViewController.h"
#import "TutorialController.h"
#import "AppDelegate.h"
#import "AvatarFormCell.h"
#import "LoginUser.h"
#import <SVProgressHUD.h>

@interface PersonalSettingController ()

@end

@implementation PersonalSettingController

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
    XLFormDescriptor *form = [self createForm:nil];
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    [self setupData];
}

-(void)setupData
{
    LoginUser *uesr = [LoginUser shareInstance];
    XLFormDescriptor *form = [self createForm:uesr];
    [self setForm:form];
}

-(XLFormDescriptor *)createForm:(LoginUser *)user
{
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"个人设置"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:avatar rowType:AvatarDescriporType title:@"头像"];
    if (user) {
        row.value = user.avatar;
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:userName rowType:XLFormRowDescriptorTypeText title:@"姓名"];
    if (user) {
        row.value = user.userName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:sex rowType:XLFormRowDescriptorTypeSelectorPush title:@"性别"];
    if (user) {
        row.value = [XLFormOptionsObject formOptionsObjectWithValue:user.sex displayText:[user.sex compare:@(0)] == NSOrderedSame ? @"女":@"男"];
    }
    row.selectorTitle = @"性别";
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"女"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"男"]
                            ];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:phoneNum rowType:XLFormRowDescriptorTypeText title:@"手机"];
    if (user) {
        row.value = user.phoneNum;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:email rowType:XLFormRowDescriptorTypeEmail title:@"邮箱"];
    if (user) {
        row.value = user.email;
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"密码修改"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"保存"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf saveAction:sender];
    };
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"退出"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf logoutAction];
    };
    [section addFormRow:row];
    
    return form;
}

-(void)saveAction:(XLFormRowDescriptor *)sender
{
    [self deselectFormRow:sender];
    NSDictionary *dic = [self formValues];
    LoginUser *user = [LoginUser createFromDictionary:dic];
    XLFormOptionsObject *sexObj = dic[sex];
    if (sexObj && ![sexObj isEqual:[NSNull null]]) {
        user.sex = [sexObj formValue];
    }
    BOOL saveSuccess = [user save];
    if (saveSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

//退出
-(void)logoutAction
{
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    if ([rootViewController isKindOfClass:[TutorialController class]] || [rootViewController isKindOfClass:[LoginBaseViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}


@end
