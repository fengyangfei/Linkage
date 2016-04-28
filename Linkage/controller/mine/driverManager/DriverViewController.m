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
#import <SVProgressHUD/SVProgressHUD.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
[row.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];\
[row.cellConfig setObject:[UIColor blackColor] forKey:@"detailTextLabel.textColor"];\
row.cellStyle = UITableViewCellStyleValue1;

@interface DriverViewController ()

@end

@implementation DriverViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    [self.tableView setEditing:NO];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [DriverUtil queryModelsFromServer:^(NSArray *models) {
            for (id model in models) {
                [DriverUtil syncToDataBase:model completion:nil];
            }
            StrongSelf
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                [strongSelf setupData];
            }];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItems = @[editBtn, addBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupData];
}

- (void)setupData
{
    WeakSelf
    [DriverUtil queryModelsFromDataBase:^(NSArray *models) {
        [weakSelf initializeForm:models];
    }];
}

- (void)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    for (Driver *model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:model.name];
        RowUI
        row.value = model;
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

#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
        [row.sectionDescriptor removeFormRowAtIndex:indexPath.row];
        [SVProgressHUD show];
        [DriverUtil deleteFromServer:row.value success:^(id responseData) {
            StrongSelf
            [DriverUtil deleteFromDataBase:row.value completion:^{
                [SVProgressHUD dismiss];
                [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
                [strongSelf setupData];
            }];
        } failure:^(NSError *error) {
            
        }];
    }
}

@end