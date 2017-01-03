//
//  VCMineViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCMineViewController.h"
#import "MenuItem.h"

@interface VCMineViewController ()

@end

@implementation VCMineViewController


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
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"我的信息"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:@""];
    row.value = [MenuItem createItemWithTitle:@"头像"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:@""];
    row.value = [MenuItem createItemWithTitle:@"昵称"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:@""];
    row.value = [MenuItem createItemWithTitle:@"手机号码"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:@""];
    row.value = [MenuItem createItemWithTitle:@"性别"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:@""];
    row.value = [MenuItem createItemWithTitle:@"所属国家"];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
}

-(void)inviteAction:(XLFormRowDescriptor *)sender
{
    [self deselectFormRow:sender];
}

@end
