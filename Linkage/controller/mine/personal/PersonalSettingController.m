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
#import "ChangePasswordController.h"
#import "XLFormValidator+Regex.h"
#import <SVProgressHUD.h>
#import <Mantle/Mantle.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
row.cellStyle = UITableViewCellStyleValue1;

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
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
    [self setupData];
}

-(void)setupData
{
    LoginUser *user = [LoginUser shareInstance];
    if (user) {
        XLFormDescriptor *form = [self createForm:user];
        [self setForm:form];
    }
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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"avatar" rowType:AvatarDescriporType title:@"头像"];
    if (user) {
        row.value = user.icon;
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText title:@"姓名"];
    if (user) {
        row.value = user.realName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"gender" rowType:XLFormRowDescriptorTypeSelectorPush title:@"性别"];
    if (user) {
        row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(user.gender) displayText:user.gender == Male ? @"男": @"女"];
    }
    row.selectorTitle = @"性别";
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"F" displayText:@"女"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@"M" displayText:@"男"]
                            ];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"mobile" rowType:XLFormRowDescriptorTypeText title:@"手机"];
    if (user) {
        row.value = user.mobile;
    }
    [row addValidator:[XLFormValidator phoneNumValidator]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeEmail title:@"邮箱"];
    if (user) {
        row.value = user.email;
    }
    [row addValidator:[XLFormValidator emailRegexValidator]];
    [section addFormRow:row];
    
    Company *company = [Company shareInstance];
    if (company && company.companyName) {
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"所属企业"];
        RowUI
        row.disabled = @YES;
        row.value = company.companyName;
        [section addFormRow:row];
    }
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"密码修改"];
    row.action.viewControllerClass = [ChangePasswordController class];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"保存"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf saveAction:sender];
    };
    [section addFormRow:row];
    
    return form;
}

//保存
-(void)saveAction:(XLFormRowDescriptor *)sender
{
    [self deselectFormRow:sender];
    
    NSArray *validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        NSError *error = [validationErrors firstObject];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    NSMutableDictionary *dic = [[self formValues] mutableCopy];
    dic[@"gender"] = [dic[@"gender"] valueData];
    dic[@"username"] = dic[@"name"];
    LoginUser *modifyUser = [MTLJSONAdapter modelOfClass:[LoginUser class] fromJSONDictionary:dic error:nil];
    LoginUser *defalutUser = [LoginUser shareInstance];
    [defalutUser mergeValuesForMergeKeysFromModel:modifyUser];
    BOOL saveSuccess = [defalutUser save];
    if (saveSuccess) {
        NSError *error;
        NSDictionary *parameter = [MTLJSONAdapter JSONDictionaryFromModel:modifyUser error:&error];
        parameter = [parameter mtl_dictionaryByAddingEntriesFromDictionary:[LoginUser shareInstance].baseHttpParameter];
        NSLog(@"%@", parameter);
        if (!error) {
            [[YGRestClient sharedInstance] postForObjectWithUrl:ModInfomationUrl form:parameter success:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
        }else{
            NSLog(@"%@", error);
        }
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

@end
