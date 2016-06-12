//
//  AddStaffViewController.m
//  Linkage
//
//  Created by Mac mini on 16/6/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddStaffViewController.h"
#import "Staff.h"
#import "StaffModel.h"
#import "StaffUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddStaffViewController ()

@end

@implementation AddStaffViewController

@synthesize rowDescriptor = _rowDescriptor;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm:nil];
    }
    return self;
}

- (void)initializeForm:(Staff *)car
{
    XLFormDescriptor *form = [self createForm:car];
    self.form = form;
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self initializeForm:rowDescriptor.value];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
}

-(XLFormDescriptor *)createForm:(Staff *)staff
{
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"信息"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"license" rowType:XLFormRowDescriptorTypeText title:@"名称"];
    row.value = @"";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"business_insure_data" rowType:XLFormRowDescriptorTypeDate title:@"日期"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"insure_company" rowType:XLFormRowDescriptorTypeText title:@""];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注信息"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"保存"];
    row.action.formBlock  = ^(XLFormRowDescriptor * sender){
        [weakSelf submitForm:sender];
    };
    [section addFormRow:row];
    
    return form;
}

-(void)submitForm:(XLFormRowDescriptor *)row
{
    WeakSelf
    [self deselectFormRow:row];
    NSArray *errors = [self formValidationErrors];
    if (errors && errors.count > 0) {
        [self showFormValidationError:errors[0]];
        return;
    }
    NSDictionary *formValues = [self formValues];
    Staff *model = (Staff *)[StaffUtil modelFromXLFormValue:formValues];
    //同步到服务端
    [SVProgressHUD show];
    [StaffUtil syncToServer:model success:^(id responseData) {
        NSString *modelId = responseData[@"staff_id"];
        if (modelId) {
            model.staffId = modelId;
            //同步到数据库
            StrongSelf
            [StaffUtil syncToDataBase:model completion:^{
                [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                    [SVProgressHUD dismiss];
                }];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

@end
