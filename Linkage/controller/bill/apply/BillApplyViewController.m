//
//  BillApplyViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/17.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillApplyViewController.h"
#import "CargoFormCell.h"
#import "CargoModel.h"
#import "CargoTypeViewController.h"
#import "CargoFormRowDescriptor.h"

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
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"billNum" rowType:XLFormRowDescriptorTypeText title:@"订单号"];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"subCompany" rowType:XLFormRowDescriptorTypeText title:@"承运商"];
    row.required = YES;
    [section addFormRow:row];
    
    //货柜
    section = [XLFormSectionDescriptor formSectionWithTitle:@"" sectionOptions:XLFormSectionOptionCanInsert|XLFormSectionOptionCanDelete sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    row = [CargoFormRowDescriptor formRowDescriptorWithTag:nil rowType:kCargoRowDescriptroType];
    NSDictionary *dic = [CargoTypeViewController cargoTypes];
    NSNumber *key = @(1);
    row.value = [CargoModel cargoModelWithValue:key displayText:[dic objectForKey:key] cargoCount:nil];
    row.action.viewControllerClass = [CargoTypeViewController class];
    [[row cellConfig] setObject:@"输入货柜数量" forKey:@"rightTextField.placeholder"];
    section.multivaluedRowTemplate = [row copy];
    [section.multivaluedAddButton.cellConfig setObject:@"添加货柜" forKey:@"textLabel.text"];
    [section addFormRow:row];
    
    //日期
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"address" rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"XLFormRowDescriptorTypeDateInline" rowType:XLFormRowDescriptorTypeText title:@"到达时间"];
    [section addFormRow:row];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"XLFormRowDescriptorTypeDateInline" rowType:XLFormRowDescriptorTypeButton title:@"到达时间"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"arrivate" rowType:XLFormRowDescriptorTypeButton title:@"提货港口"];
    
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
