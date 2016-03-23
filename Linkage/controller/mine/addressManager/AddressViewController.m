//
//  AddressViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressViewController.h"
#import "AddAddressViewController.h"
#import "AddressCell.h"
#import "AddressWrapper.h"
#import "AddressModel.h"

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddressAction:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupForm];
}

- (void)setupForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptor];
    for (Address *address in [self findDataFromLocal]) {
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"nil" rowType:kAddressRowDescriptroType];
        row.value = address;
        [section addFormRow:row];
    }
    self.form = form;
}

-(NSArray *)findDataFromLocal
{
    NSArray *models = [AddressModel findAll];
    return [AddressWrapper generateAddress:models];
}

#pragma mark - action
-(void)addAddressAction:(id)sender
{
    AddAddressViewController *addAddressVC = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddressVC animated:YES];
}


@end
