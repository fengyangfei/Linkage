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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBillApplyViewController)];
    __weak __typeof(self.leftTableView) weakLeftView = self.leftTableView;
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [OrderUtil queryModelsFromServer:^(NSArray *orders) {
            for (Order *order in orders) {
                [OrderUtil syncToDataBase:order completion:nil];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
            [weakSelf setupData];
            [weakLeftView.mj_header endRefreshing];
        }];
    }];
    
    __weak __typeof(self.rightTableView) weakRightView = self.rightTableView;
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [OrderUtil queryModelsFromServer:^(NSArray *orders) {
            for (Order *order in orders) {
                [OrderUtil syncToDataBase:order completion:nil];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
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
    [OrderUtil queryModelsFromDataBase:^(NSArray *orders) {
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