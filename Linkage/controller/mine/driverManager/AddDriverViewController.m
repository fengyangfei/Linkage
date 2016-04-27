//
//  AddDriverViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddDriverViewController.h"
#import "DriverUtil.h"
#import "Driver.h"
#import "DriverModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddDriverViewController ()

@end

@implementation AddDriverViewController

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
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"添加"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"driver_name" rowType:XLFormRowDescriptorTypeText title:@"司机姓名"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"driver_mobile" rowType:XLFormRowDescriptorTypeText title:@"司机电话"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"license" rowType:XLFormRowDescriptorTypeText title:@"车牌"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"保存地址"];
    row.action.formBlock  = ^(XLFormRowDescriptor * sender){
        [weakSelf submitForm:sender];
    };
    [section addFormRow:row];
    
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
}

-(void)submitForm:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    NSArray *errors = [self formValidationErrors];
    if (errors && errors.count > 0) {
        [self showFormValidationError:errors[0]];
        return;
    }
    NSDictionary *formValues = [self formValues];
    Driver *driver = (Driver *)[DriverUtil modelFromXLFormValue:formValues];
    //同步到服务端
    [DriverUtil syncToServer:driver success:^(id responseData) {
        NSString *driverId = responseData[@"driver_id"];
        driver.driverId = driverId;
        //同步到数据库
        [DriverUtil syncToDataBase:driver completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (contextDidSave) {
                [SVProgressHUD showSuccessWithStatus:@"单据缓存成功"];
            }
        }];
        [SVProgressHUD showSuccessWithStatus:@"单据保存成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"单据保存失败"];
    }];
    
}


@end
