//
//  BillViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillViewController.h"
#import "OrderCell.h"
#import "BillTypeViewController.h"
#import "BillDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <XLForm/XLForm.h>
#import "LoginUser.h"
#import "Order.h"
#import "OrderUtil.h"
#import "XLFormDataSource.h"
#import "BillDataSource.h"
#import "SearchViewController.h"
#import "BillApplyViewController.h"

@interface BillViewController ()
@property (nonatomic, strong) XLFormDataSource *todoDS;
@property (nonatomic, strong) XLFormDataSource *doneDS;
@end

@implementation BillViewController
@synthesize leftTableView = _leftTableView;
@synthesize rightTableView = _rightTableView;

-(void)dealloc
{
    _todoDS = nil;
    _doneDS = nil;
}

-(void)viewDidLoad
{
    WeakSelf
    [super viewDidLoad];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    if ([LoginUser shareInstance].ctype == UserTypeCompanyAdmin) {
        //只有厂商才能下订单
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBillTypeViewController)];
        self.navigationItem.rightBarButtonItems = @[addItem, searchItem];
    }else{
        self.navigationItem.rightBarButtonItem = searchItem;
    }
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *parameter = @{
                                    @"type":@(-1),
                                    @"status":@(1)
                                    };
        parameter = [[LoginUser shareInstance].basePageHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
        [OrderUtil queryModelsFromServer:parameter completion:^(NSArray *orders) {
            if (orders.count > 0) {
                for (Order *order in orders) {
                    [OrderUtil syncToDataBase:order completion:nil];
                }
            }else{
                [OrderUtil truncateTodoOrders];
            }
            StrongSelf
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError *error) {
                [strongSelf setupTodoData];
            }];
            [weakSelf.leftTableView.mj_header endRefreshing];
        }];
    }];
    
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary *parameter = @{
                                    @"type":@(-1),
                                    @"status":@(2)
                                    };
        parameter = [[LoginUser shareInstance].basePageHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
        [OrderUtil queryModelsFromServer:parameter completion:^(NSArray *orders) {
            if (orders.count > 0) {
                for (Order *order in orders) {
                    [OrderUtil syncToDataBase:order completion:nil];
                }
            }else{
                [OrderUtil truncateDoneOrders];
            }
            StrongSelf
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                [strongSelf setupDoneData];
            }];
            [weakSelf.rightTableView.mj_header endRefreshing];
        }];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self.leftTableView.mj_header isRefreshing]) {
        [self.leftTableView.mj_header beginRefreshing];
    }
}

- (void)segmentedControlChangeIndex:(NSInteger)index
{
    if (index == 1) {
        [self setupDoneData];
    }
}

-(void)setupTodoData
{
    WeakSelf
    NSPredicate *todoPredicate = [NSPredicate predicateWithFormat:@"userId = %@ AND status != %@", [LoginUser shareInstance].cid, @(OrderStatusCompletion)];
    [OrderUtil queryModelsFromDataBase:todoPredicate completion:^(NSArray *orders) {
        [weakSelf.todoDS setForm:[weakSelf createForm:orders]];
    }];
}

-(void)setupDoneData
{
    WeakSelf
    NSPredicate *donePredicate = [NSPredicate predicateWithFormat:@"userId = %@ AND status == %@", [LoginUser shareInstance].cid, @(OrderStatusCompletion)];
    [OrderUtil queryModelsFromDataBase:donePredicate completion:^(NSArray *orders) {
        [weakSelf.doneDS setForm:[weakSelf createForm:orders]];
    }];
}

-(void)pushBillTypeViewController
{
    BillTypeViewController *controller = [[BillTypeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)searchAction:(id)sender
{
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

-(XLFormDescriptor *)createForm:(NSArray *)orders
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;

    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (Order *order in orders) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:PendingOrderDescriporType];
        row.value = order;
        if (order.status == OrderStatusPending || order.status == OrderStatusDenied) {
            row.action.viewControllerClass = [BillApplyViewController class];
        }else{
            row.action.viewControllerClass = [BillDetailViewController class];
        }
        [section addFormRow:row];
    }
    return form;
}

#pragma mark - 属性
-(UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _todoDS = [[TodoDataSource alloc] initWithViewController:self tableView:_leftTableView];
        _leftTableView.dataSource = _todoDS;
        _leftTableView.delegate = _todoDS;
        _leftTableView.sectionFooterHeight = 0;
        _leftTableView.tableFooterView = [UIView new];
    }
    return _leftTableView;
}

-(UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _doneDS = [[DoneDataSource alloc] initWithViewController:self tableView:_rightTableView];
        _rightTableView.dataSource = _doneDS;
        _rightTableView.delegate = _doneDS;
        _rightTableView.sectionFooterHeight = 0;
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}

@end