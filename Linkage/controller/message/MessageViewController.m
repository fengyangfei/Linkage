//
//  MessageViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableCell.h"

@implementation MessageViewController

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
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"消息"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    for (int i = 0; i< 10 ; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:MessageDescriporType title:@"消息"];
        row.disabled = @YES;
        [section addFormRow:row];
    }
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
}

@end
