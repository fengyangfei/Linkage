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
#import "Address.h"

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    [self setupData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddressAction:)];
}

- (void)setupData
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptor];
    for (Address *address in [self dataFromLocal]) {
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"nil" rowType:kAddressRowDescriptroType];
        row.value = address;
        [section addFormRow:row];
    }
    self.form = form;
}

-(NSArray *)dataFromLocal
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        Address *address = [[Address alloc]init];
        address.target = @"联系方式";
        address.specific = @"12312123123123123";
        [array addObject:address];
    }
    return [array copy];
}

#pragma mark - action
-(void)addAddressAction:(id)sender
{
    AddAddressViewController *addAddressVC = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddressVC animated:YES];
}


@end
