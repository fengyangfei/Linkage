//
//  DriverManageViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverManageViewController.h"
#import "Driver.h"
#import "DriverUtil.h"
#import "LoginUser.h"
#import "AddDriverViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface DriverManageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *drivers;
@end

@implementation DriverManageViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"司机管理";
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItems = @[editBtn, addBtn];

    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
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
    [DriverUtil queryModelsFromDataBase:^(NSArray *models) {
        weakSelf.drivers = models;
        [weakSelf.tableView reloadData];
    }];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.drivers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Driver *driver = [self.drivers objectAtIndex:indexPath.row];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"typeCell"];
    }
    cell.textLabel.text = driver.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 电话（%@）", driver.license, driver.mobile];
    cell.imageView.image = [UIImage imageNamed:@"tab_icon_selection_highlight"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Driver *driver = (Driver *)[self.drivers objectAtIndex:indexPath.row];
    AddDriverViewController *viewContrller = [[AddDriverViewController alloc]initWithDriver:driver];
    [self.navigationController pushViewController:viewContrller animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableView *)tableView
{
    WeakSelf
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        __weak __typeof(_tableView) weakView = _tableView;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [DriverUtil queryModelsFromServer:^(NSArray *models) {
                for (id model in models) {
                    [DriverUtil syncToDataBase:model completion:nil];
                }
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                [weakSelf setupData];
                [weakView.mj_header endRefreshing];
            }];
        }];
    }
    return _tableView;
}
@end