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
        [weakSelf queryTodoDataFromServer:^{
            StrongSelf
            [strongSelf.leftTableView.mj_header endRefreshing];
        }];
    }];
    
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryDoneDataFromServer:^{
            StrongSelf
            [strongSelf.rightTableView.mj_header endRefreshing];
        }];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    WeakSelf
    [super viewDidAppear:animated];
    [self setupTodoData:^(NSArray *orders) {
        if (orders.count <= 0) {
            if (![weakSelf.leftTableView.mj_header isRefreshing]) {
                [weakSelf.leftTableView.mj_header beginRefreshing];
            }
        }
    }];
}

- (void)segmentedControlChangeIndex:(NSInteger)index
{
    if (index == 1) {
        WeakSelf
        [self setupDoneData:^(NSArray *orders) {
            if (orders.count <= 0) {
                if(![weakSelf.rightTableView.mj_header isRefreshing]){
                    [weakSelf.rightTableView.mj_header beginRefreshing];
                }
            }
        }];
    }
}

-(void)queryTodoDataFromServer:(void(^)(void))block
{
    NSDictionary *parameter = @{
                                @"type":@(-1),
                                @"status":@(1)
                                };
    WeakSelf
    parameter = [[LoginUser shareInstance].basePageHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [OrderUtil queryModelsFromServer:parameter completion:^(NSArray *orders) {
        [OrderUtil truncateTodoOrders];
        for (Order *order in orders) {
            [OrderUtil syncToDataBase:order completion:nil];
        }
        StrongSelf
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError *error) {
            [strongSelf setupTodoData:nil];
        }];
        if (block) {
            block();
        }
    }];
}

-(void)queryDoneDataFromServer:(void(^)(void))block
{
    NSDictionary *parameter = @{
                                @"type":@(-1),
                                @"status":@(2)
                                };
    WeakSelf
    parameter = [[LoginUser shareInstance].basePageHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [OrderUtil queryModelsFromServer:parameter completion:^(NSArray *orders) {
        [OrderUtil truncateDoneOrders];
        for (Order *order in orders) {
            [OrderUtil syncToDataBase:order completion:nil];
        }
        StrongSelf
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
            [strongSelf setupDoneData:nil];
        }];
        if (block) {
            block();
        }
    }];
}

-(void)setupTodoData:(void(^)(NSArray *orders))completion
{
    WeakSelf
    NSPredicate *todoPredicate = [NSPredicate predicateWithFormat:@"userId = %@ AND (status == %@ OR status == %@)", [LoginUser shareInstance].cid, @(OrderStatusPending), @(OrderStatusExecuting)];
    [OrderUtil queryModelsFromDataBase:todoPredicate completion:^(NSArray *orders) {
        [weakSelf.todoDS setForm:[weakSelf createTodoForm:orders]];
        if (completion) {
            completion(orders);
        }
    }];
}

-(void)setupDoneData:(void(^)(NSArray *orders))completion
{
    WeakSelf
    NSPredicate *donePredicate = [NSPredicate predicateWithFormat:@"userId = %@ AND (status == %@ OR status == %@ OR status == %@)", [LoginUser shareInstance].cid, @(OrderStatusCompletion), @(OrderStatusDenied), @(OrderStatusCancelled)];
    [OrderUtil queryModelsFromDataBase:donePredicate completion:^(NSArray *orders) {
        [weakSelf.doneDS setForm:[weakSelf createDoneForm:orders]];
        if (completion) {
            completion(orders);
        }
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

-(XLFormDescriptor *)createDoneForm:(NSArray *)orders
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    
    form = [XLFormDescriptor formDescriptor];
    
    NSPredicate *donePredicate = [NSPredicate predicateWithFormat:@"status == %@", @(OrderStatusCompletion)];
    NSArray *doneOrders = [orders filteredArrayUsingPredicate:donePredicate];
    if (doneOrders && doneOrders.count > 0) {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"已完成"];
        [form addFormSection:section];
        [self addOrders:doneOrders toSection:section];
    }
    
    NSPredicate *deniedPredicate = [NSPredicate predicateWithFormat:@"status == %@", @(OrderStatusDenied)];
    NSArray *deniedOrders = [orders filteredArrayUsingPredicate:deniedPredicate];
    if (deniedOrders && deniedOrders.count > 0) {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"被拒绝"];
        [form addFormSection:section];
        [self addOrders:deniedOrders toSection:section];
    }
    
    NSPredicate *cancelledPredicate = [NSPredicate predicateWithFormat:@"status == %@", @(OrderStatusCancelled)];
    NSArray *cancelledOrders = [orders filteredArrayUsingPredicate:cancelledPredicate];
    if (cancelledOrders && cancelledOrders.count > 0) {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"已取消"];
        [form addFormSection:section];
        [self addOrders:cancelledOrders toSection:section];
    }
    
    return form;
}

-(XLFormDescriptor *)createTodoForm:(NSArray *)orders
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;

    form = [XLFormDescriptor formDescriptor];

    NSPredicate *todoPredicate = [NSPredicate predicateWithFormat:@"status == %@", @(OrderStatusPending)];
    NSArray *todoOrders = [orders filteredArrayUsingPredicate:todoPredicate];
    if (todoOrders && todoOrders.count > 0) {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"未接单"];
        [form addFormSection:section];
        [self addOrders:todoOrders toSection:section];
    }
    
    NSPredicate *doingPredicate = [NSPredicate predicateWithFormat:@"status == %@", @(OrderStatusExecuting)];
    NSArray *doingOrders = [orders filteredArrayUsingPredicate:doingPredicate];
    if (doingOrders && doingOrders.count > 0) {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"处理中"];
        [form addFormSection:section];
        [self addOrders:doingOrders toSection:section];
    }

    return form;
}

-(void)addOrders:(NSArray *)orders toSection:(XLFormSectionDescriptor *)section
{
    for (Order *order in orders) {
        NSString *rowType = PendingOrderDescriporType;
        if(order.status == OrderStatusCompletion){
            if ([LoginUser shareInstance].ctype == UserTypeCompanyAdmin || [LoginUser shareInstance].ctype == UserTypeCompanyUser) {
                rowType = CompletionOrderDescriporType;
            }
        }
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:rowType];
        row.value = order;
        //只有厂商管理员并被拒绝的订单才能修改订单，其他状态只能查看订单详情
        if (order.status == OrderStatusDenied && [LoginUser shareInstance].ctype == UserTypeCompanyAdmin) {
            if(order.type == OrderTypeExport){
                row.action.viewControllerClass = [BillExportApplyViewController class];
            }else if(order.type == OrderTypeImport){
                row.action.viewControllerClass = [BillImportApplyViewController class];
            }else if(order.type == OrderTypeSelf){
                row.action.viewControllerClass = [BillSelfApplyViewController class];
            }else{
                row.action.viewControllerClass = [BillApplyViewController class];
            }
        }else{
            row.action.viewControllerClass = [BillDetailViewController class];
        }
        [section addFormRow:row];
    }
}

#pragma mark - 属性
-(UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _doneDS = [[DoneDataSource alloc] initWithViewController:self tableView:_rightTableView];
        _rightTableView.dataSource = _doneDS;
        _rightTableView.delegate = _doneDS;
        _rightTableView.sectionFooterHeight = 0;
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}

@end