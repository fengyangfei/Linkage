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
            for (Order *order in orders) {
                [OrderUtil syncToDataBase:order completion:nil];
            }
            [weakSelf setupData];
            [weakLeftView.mj_header endRefreshing];
        }];
    }];
    
    __weak __typeof(self.rightTableView) weakRightView = self.rightTableView;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [OrderUtil queryOrdersFromServer:^(NSArray *orders) {
            for (Order *order in orders) {
                [OrderUtil syncToDataBase:order completion:nil];
            }
            [weakSelf setupData];
            [weakRightView.mj_header endRefreshing];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupData];
}

-(void)setupData
{
    WeakSelf
    [OrderUtil queryOrdersFromDataBase:^(NSArray *orders) {
        [weakSelf.todoDS setForm:[weakSelf createForm:orders]];
        [weakSelf.doneDS setForm:[weakSelf createForm:orders]];
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
    
}

-(XLFormDescriptor *)createForm:(NSArray *)orders
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;

    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (Order *order in orders) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:TodoBillDescriporType];
        row.value = order;
        row.action.viewControllerClass = [BillDetailViewController class];
        [section addFormRow:row];
    }
    return form;
}

@end