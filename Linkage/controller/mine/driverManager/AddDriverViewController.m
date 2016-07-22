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
#import "XLFormValidator+Regex.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddDriverViewController ()

@end

@implementation AddDriverViewController
@synthesize rowDescriptor = _rowDescriptor;

- (instancetype)init
{
    return [self initWithDriver:nil];
}

- (instancetype)initWithDriver:(Driver *)driver
{
    self = [super init];
    if (self) {
        [self initializeForm:driver];
    }
    return self;
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self initializeForm:rowDescriptor.value];
}

- (void)initializeForm:(Driver *)driver
{
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"司机信息"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"driver_name" rowType:XLFormRowDescriptorTypeText title:@"司机姓名"];
    row.value = driver?driver.name:@"";
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"driver_mobile" rowType:XLFormRowDescriptorTypeText title:@"司机电话"];
    row.value = driver?driver.mobile:@"";
    row.required = YES;
    [row addValidator:[XLFormValidator phoneNumValidator]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"license" rowType:XLFormRowDescriptorTypeText title:@"车牌"];
    row.value = driver?driver.license:@"";
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    NSString *title = driver?@"修改":@"保存";
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:title];
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
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
}

-(void)submitForm:(XLFormRowDescriptor *)row
{
    WeakSelf
    [self deselectFormRow:row];
    NSArray *errors = [self formValidationErrors];
    if (errors && errors.count > 0) {
        NSError *error = [errors firstObject];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    NSDictionary *formValues = [self formValues];
    Driver *driver = (Driver *)[DriverUtil modelFromXLFormValue:formValues];
    if (_rowDescriptor.value) {
        driver.driverId = ((Driver *)_rowDescriptor.value).driverId;
    }
    //同步到服务端
    [SVProgressHUD show];
    [DriverUtil syncToServer:driver success:^(id responseData) {
        NSString *driverId = responseData[@"driver_id"];
        if (driverId) {
            driver.driverId = driverId;
            //同步到数据库
            StrongSelf
            [DriverUtil syncToDataBase:driver completion:^{
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
