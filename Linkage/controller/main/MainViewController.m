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
#import "CycleScrollCell.h"


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize tableView = _tableView;

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
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:CycleScrollDescriporRowType];
    [section addFormRow:row];
    
    for (Company *company in [LoginUser shareInstance].companies) {
        NSString *rowType = CompanyDescriporType;
        if ([LoginUser shareInstance].ctype == UserTypeCompanyAdmin) {
            rowType = CompanyDescriporType;
        }else if([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin) {
            rowType = CompanyInfoDescriporType;
        }
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:rowType];
        row.value = company;
        [section addFormRow:row];
    }
    return form;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
