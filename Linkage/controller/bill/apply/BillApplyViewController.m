//
//  BillApplyViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/17.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillApplyViewController.h"
#import "CargoFormCell.h"
#import "CargoTypeViewController.h"

@interface BillApplyViewController ()

@end

@implementation BillApplyViewController

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
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"billNum" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"订单号"];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"subCompany" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"承运商"];
    row.required = YES;
    [section addFormRow:row];
    
    //货柜
    section = [XLFormSectionDescriptor formSectionWithTitle:@"" sectionOptions:XLFormSectionOptionCanInsert|XLFormSectionOptionCanDelete sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:kCargoRowDescriptroType];
    row.action.viewControllerClass = [CargoTypeViewController class];
    [[row cellConfig] setObject:@"输入货柜数量" forKey:@"rightTextField.placeholder"];
    section.multivaluedRowTemplate = [row copy];
    [section.multivaluedAddButton.cellConfig setObject:@"添加货柜" forKey:@"textLabel.text"];
    [section addFormRow:row];
    
    //日期
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"date" rowType:XLFormRowDescriptorTypeButton title:@"日期"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"sendDate" rowType:XLFormRowDescriptorTypeButton title:@"送货时间"];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"about" rowType:XLFormRowDescriptorTypeButton title:@"提交订单"];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@implementation BillImportApplyViewController


@end

@implementation BillExportApplyViewController


@end
