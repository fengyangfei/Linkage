//
//  StaffViewController.m
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffUtil.h"
#import "StaffViewController.h"
#import "AddStaffViewController.h"
#import "StaffTableViewCell.h"

@implementation StaffViewController

-(Class)modelUtilClass
{
    return [StaffUtil class];
}

-(Class)viewControllerClass
{
    return [AddStaffViewController class];
}

- (void)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    for (id model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:StaffDescriporRowType];
        row.value = model;
        row.action.viewControllerClass = self.viewControllerClass;
        [section addFormRow:row];
    }
    self.form = form;
}

-(void)setupNavigationItem
{
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = editBtn;
}
@end
