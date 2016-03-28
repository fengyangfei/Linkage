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
    
    for (int i = 0; i < 10; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:avatar rowType:CompanyDescriporType];
        row.action.viewControllerClass = [BillTypeViewController class];
        [section addFormRow:row];
    }
    
    return form;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
