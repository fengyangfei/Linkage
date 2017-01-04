//
//  VCMineViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCMineViewController.h"
#import "MenuCell.h"
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
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"我的"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMineHeader];
    row.value = [MenuItem createItemWithTitle:@"头像" andIconName:@"v_user" andClass:nil];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:@"设置" andIconName:@"setting" andClass:nil];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:@"喜好设置" andIconName:@"mark" andClass:nil];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:@"建议反馈" andIconName:@"advance" andClass:nil];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:@"帮助说明" andIconName:@"explain" andClass:nil];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:@"关于Vcode" andIconName:@"choice" andClass:nil];
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
