//
//  CompanyInfoViewController.m
//  Linkage
//
//  Created by Mac mini on 16/6/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "Company.h"
#import "CompanyUtil.h"

#define RowUI row.cellStyle = UITableViewCellStyleValue1;\
[row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
[row.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];\

@interface CompanyInfoViewController ()

@end

@implementation CompanyInfoViewController
@synthesize rowDescriptor = _rowDescriptor;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    [self setupData];
}

-(void)setupData
{
    Favorite *favorite = self.rowDescriptor.value;
    if (favorite) {
        [CompanyUtil queryModelFromServer:favorite completion:^(id<MTLJSONSerializing> result) {
            XLFormDescriptor *form = [self createForm:(Company *)result];
            [self setForm:form];
        }];
    }
    
    Company *company = [Company shareInstance];
    if(company){
    }
}

-(XLFormDescriptor *)createForm:(Company *)company
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"company_name" rowType:XLFormRowDescriptorTypeButton title:@"企业名称"];
    if (company) {
        row.value = company.companyName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"description" rowType:XLFormRowDescriptorTypeButton title:@"企业简介"];
    if (company) {
        row.value = company.introduction;
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"contact_name" rowType:XLFormRowDescriptorTypeButton title:@"企业联系人"];
    if (company) {
        row.value = company.contactName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"contact_address" rowType:XLFormRowDescriptorTypeButton title:@"企业地址"];
    if (company) {
        row.value = company.address;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeButton title:@"企业邮箱"];
    if (company) {
        row.value = company.email;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"fax" rowType:XLFormRowDescriptorTypeButton title:@"传真"];
    if (company) {
        row.value = company.fax;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"url" rowType:XLFormRowDescriptorTypeButton title:@"企业网址"];
    if (company) {
        row.value = company.url;
    }
    [section addFormRow:row];
    
    return form;
}


@end
