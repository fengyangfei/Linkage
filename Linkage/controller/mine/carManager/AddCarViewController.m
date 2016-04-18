//
//  AddCarViewController.m
//  Linkage
//
//  Created by lihaijian on 16/4/18.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddCarViewController.h"

@implementation AddCarViewController

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
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
}

-(XLFormDescriptor *)createForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"车辆信息"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"number" rowType:XLFormRowDescriptorTypeText title:@"车牌号码"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"carNum" rowType:XLFormRowDescriptorTypeText title:@"发动机号码"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"carId" rowType:XLFormRowDescriptorTypeText title:@"车架号"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"numDate" rowType:XLFormRowDescriptorTypeText title:@"上牌日期"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"yearDate" rowType:XLFormRowDescriptorTypeText title:@"年审日期"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"secondMonth" rowType:XLFormRowDescriptorTypeText title:@"二级维护月份"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"insurancedate" rowType:XLFormRowDescriptorTypeText title:@"交强险日期"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"insuranceTime" rowType:XLFormRowDescriptorTypeText title:@"商业险日期"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"insuranceName" rowType:XLFormRowDescriptorTypeText title:@"保险公司名称"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"remark" rowType:XLFormRowDescriptorTypeTextView title:@"备注信息"];
    [section addFormRow:row];
    
    return form;
}

@end
