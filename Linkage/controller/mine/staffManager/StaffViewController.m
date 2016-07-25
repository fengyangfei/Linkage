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
#import <SVProgressHUD/SVProgressHUD.h>

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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self confirmDelete:indexPath];
    }
}

-(void)confirmDelete:(NSIndexPath *)indexPath
{
    WeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请确认是否删除?" message:@"删除后该名员工将无法再登陆平台!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf deleteAtRow:indexPath];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

-(void)deleteAtRow:(NSIndexPath *)indexPath
{
    WeakSelf
    XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    [row.sectionDescriptor removeFormRowAtIndex:indexPath.row];
    [SVProgressHUD show];
    [self.modelUtilClass deleteFromServer:row.value success:^(id responseData) {
        StrongSelf
        [self.modelUtilClass deleteFromDataBase:row.value completion:^{
            [SVProgressHUD dismiss];
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
            [strongSelf setupData];
        }];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


@end
