//
//  BillViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillViewController.h"
#import "BillTableViewCell.h"
#import "BillDataSource.h"
#import "BillTypeViewController.h"

#import "BillDetailViewController.h"

@interface BillViewController ()

@property (nonatomic, strong) TodoDataSource *todoDS;
@property (nonatomic, strong) DoneDataSource *doneDS;
@end

@implementation BillViewController

-(void)dealloc
{
    self.todoDS = nil;
    self.doneDS = nil;
    self.leftTableView.delegate = nil;
    self.rightTableView.dataSource = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBillApplyViewController)];
    [self setupData];
}

-(void)setupData
{
    [self refreshTodoTable];
    [self refreshDoneTable];
}

-(void)refreshTodoTable
{
    self.todoDS = [[TodoDataSource alloc]initWithViewController:self tableView:self.leftTableView];
    [self.todoDS setForm:[self createForm]];
    self.leftTableView.dataSource = self.todoDS;
    self.leftTableView.delegate = self.todoDS;
    if ([self isViewLoaded]){
        [self.leftTableView reloadData];
    }
}

-(void)refreshDoneTable
{
    self.doneDS = [[DoneDataSource alloc]initWithViewController:self tableView:self.rightTableView];
    [self.doneDS setForm:[self createForm]];
    self.rightTableView.dataSource = self.doneDS;
    self.rightTableView.delegate = self.doneDS;
    if ([self isViewLoaded]){
        [self.rightTableView reloadData];
    }
}

-(void)pushBillApplyViewController
{
    BillTypeViewController *controller = [[BillTypeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(XLFormDescriptor *)createForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"未完成"];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:TodoBillDescriporType];
        row.action.viewControllerClass = [BillDetailViewController class];
        [section addFormRow:row];
    }
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"已完成"];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:TodoBillDescriporType];
        row.action.viewControllerClass = [BillDetailViewController class];
        [section addFormRow:row];
    }
    
    return form;
}

@end