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
#import <SVProgressHUD/SVProgressHUD.h>
#import <XLForm/XLForm.h>
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
    WeakSelf
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBillApplyViewController)];
    __weak __typeof(self.leftTableView) weakLeftView = self.leftTableView;
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [OrderUtil queryOrdersFromServer:^(NSArray *orders) {
            [weakSelf addRows:orders toDataSource:weakSelf.todoDS];
            [weakLeftView.mj_header endRefreshing];
        }];
    }];
    
    __weak __typeof(self.rightTableView) weakRightView = self.rightTableView;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [OrderUtil queryOrdersFromServer:^(NSArray *orders) {
            [weakSelf addRows:orders toDataSource:weakSelf.doneDS];
            [weakRightView.mj_header endRefreshing];
        }];
    }];
    
    [self setupData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)setupData
{
    [self.todoDS setForm:[self createForm:nil]];
    [self.doneDS setForm:[self createForm:nil]];
    WeakSelf
    [OrderUtil queryOrdersFromDataBase:^(NSArray *orders) {
        [weakSelf addRows:orders toDataSource:weakSelf.todoDS];
    }];
}

-(void)pushBillApplyViewController
{
    BillTypeViewController *controller = [[BillTypeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)segmentedControlChangeIndex:(NSInteger)index
{
    if (index == 0) {
        [self.leftTableView.mj_header beginRefreshing];
    }else if (index == 1){
        [self.rightTableView.mj_header beginRefreshing];
    }
}

-(XLFormDescriptor *)createForm:(NSArray *)orders
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;

    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    [self addRows:orders toSection:section];
    return form;
}

-(void)addRows:(NSArray *)orders toSection:(XLFormSectionDescriptor *)section
{
    for (Order *order in orders) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:TodoBillDescriporType];
        row.value = order;
        row.action.viewControllerClass = [BillDetailViewController class];
        [section addFormRow:row];
    }
}

-(void)addRows:(NSArray *)orders toDataSource:(XLFormDataSource *)dataSource
{
    XLFormSectionDescriptor *section = (XLFormSectionDescriptor *)[dataSource.form.formSections firstObject];
    [self addRows:orders toSection:section];
}

@end