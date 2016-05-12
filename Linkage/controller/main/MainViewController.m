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
#import "SearchViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
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

-(void)searchAction:(id)sender
{
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
