//
//  BillViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillViewController.h"
#import "BillTableViewCell.h"
#import "BillTypeViewController.h"
#import "BillDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

#import "Order.h"
#import "OrderUtil.h"

@interface BillViewController ()


@end

@implementation BillViewController

-(void)dealloc
{
    self.todoDS = nil;
    self.doneDS = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBillApplyViewController)];
    __weak __typeof(self.leftTableView) weakLeftView = self.leftTableView;
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [OrderUtil queryOrderFromServer:^(NSArray *orders) {
            [weakLeftView.mj_header endRefreshing];
        }];
    }];
    
    __weak __typeof(self.rightTableView) weakRightView = self.rightTableView;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [OrderUtil queryOrderFromServer:^(NSArray *orders) {
            [weakRightView.mj_header endRefreshing];
        }];
    }];
    
    [self setupData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupData];
}

-(void)setupData
{
    [self refreshTodoTable];
    [self refreshDoneTable];
}

-(void)refreshTodoTable
{
    if (self.todoDS) {
        [self.todoDS setForm:[self createForm]];
    }
}

-(void)refreshDoneTable
{
    if (self.doneDS){
        [self.doneDS setForm:[self createForm]];
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
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    [OrderUtil queryOrderFromDataBase:^(NSArray *orders) {
        for (Order *order in orders) {
            XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:TodoBillDescriporType];
            row.value = order;
            row.action.viewControllerClass = [BillDetailViewController class];
            [section addFormRow:row];
        }
    }];
    
    return form;
}

@end