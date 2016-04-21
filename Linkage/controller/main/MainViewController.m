//
//  MainViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "BillTypeViewController.h"
#import "LoginUser.h"
#import "Company.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
}

-(void)setupData
{
    XLFormDescriptor *form = [self createForm];
    [self setForm:form];
}

-(XLFormDescriptor *)createForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (Company *company in [LoginUser shareInstance].companies) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:CompanyDescriporType];
        row.value = company;
        [section addFormRow:row];
    }

    return form;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
