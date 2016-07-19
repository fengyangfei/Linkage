//
//  ChangePasswordController.m
//  Linkage
//
//  Created by lihaijian on 16/4/18.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "ChangePasswordController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <Mantle/Mantle.h>
#import "YGRestClient.h"
#import "LoginUser.h"
#import "CocoaSecurity.h"
#import "XLFormValidator+Regex.h"

@implementation ChangePasswordController

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
    XLFormDescriptor *form = [self createForm];
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
    //[self bindViewModel:self.form];
}

-(void)bindViewModel:(XLFormDescriptor *)form
{
    NSMutableArray *signals = [NSMutableArray array];
    for (XLFormSectionDescriptor * section in form.formSections) {
        for (XLFormRowDescriptor * row in section.formRows) {
            if (row.tag.length > 0){
                [signals addObject:RACObserve(row, value)];
            }
        }
    }
    XLFormRowDescriptor *lastRow = [form formRowAtIndex:[NSIndexPath indexPathForRow:0 inSection:1]];
    RAC(lastRow, disabled) = [RACSignal combineLatest:signals reduce:^id(NSString *password, NSString *newpassword, NSString *confirmpassword){
        if (password && password.length > 0 && newpassword && newpassword.length > 0 && confirmpassword && confirmpassword.length > 0 && [newpassword isEqualToString:confirmpassword]) {
            return @(NO);
        }
        return @(YES);
    }];
}

-(XLFormDescriptor *)createForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"修改密码"];
    section = [XLFormSectionDescriptor formSection];
    section.footerTitle = @"密码长度至少6个字符，最多32个字符";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"password" rowType:XLFormRowDescriptorTypePassword title:@"当前密码"];
    row.required = @YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"newpassword" rowType:XLFormRowDescriptorTypePassword title:@"新密码"];
    row.required = @YES;
    [row addValidator:[XLFormValidator passswordValidator]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"confirmpassword" rowType:XLFormRowDescriptorTypePassword title:@"确认新密码"];
    row.required = @YES;
    [row addValidator:[XLFormValidator passswordValidator]];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    WeakSelf
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"修改"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf clickAction:sender];
    };
    [section addFormRow:row];
    
    return form;
}

//修改
-(void)clickAction:(XLFormRowDescriptor *)sender
{
    [self deselectFormRow:sender];
    
    NSArray *validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        NSError *error = [validationErrors firstObject];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    WeakSelf
    NSDictionary *forValues = [self.form formValues];
    if (![forValues[@"newpassword"] isEqualToString:forValues[@"confirmpassword"] ]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    NSDictionary *parameter = @{
                                @"new_password":[forValues[@"newpassword"] md5],
                                @"old_password":[forValues[@"password"] md5]
                                };
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [[YGRestClient sharedInstance]postForObjectWithUrl:ModPasswordUrl form:parameter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

@end
