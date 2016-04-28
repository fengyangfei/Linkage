//
//  DriverViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverViewController.h"
#import "Driver.h"
#import "DriverUtil.h"
#import "LoginUser.h"
#import "AddDriverViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface DriverViewController ()

@end

@implementation DriverViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [DriverUtil queryModelsFromServer:^(NSArray *models) {
            for (id model in models) {
                [DriverUtil syncToDataBase:model completion:nil];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [weakSelf initializeForm:models];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItems = @[editBtn, addBtn];
}

- (void)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (Driver *driver in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton];
        row.value = driver;
        row.action.viewControllerClass = [AddDriverViewController class];
        [section addFormRow:row];
    }
    self.form = form;
}

#pragma mark - action
-(void)editAction:(UIBarButtonItem *)sender
{
    if(!self.tableView.isEditing){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editAction:)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    }
    [self.tableView setEditing:!self.tableView.isEditing];
}

-(void)addAction:(UIBarButtonItem *)sender
{
    AddDriverViewController *addViewController = [[AddDriverViewController alloc]init];
    [self.navigationController pushViewController:addViewController animated:YES];
}

@end