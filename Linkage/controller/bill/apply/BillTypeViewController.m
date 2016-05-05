//
//  BillTypeViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillTypeViewController.h"
#import "BillApplyViewController.h"
#import "Order.h"
#import "Company.h"

#define kBillTypeArray @[@"出口订单",@"进口订单",@"自备柜配送"]
@interface BillTypeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Company *company;
@end

@implementation BillTypeViewController
@synthesize tableView = _tableView;

-(instancetype)initWithCompany:(Company *)company
{
    self = [super init];
    if (self) {
        self.company = company;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单类型";
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
    NSLog(@"viewAppear");
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"typeCell"];
    }
    cell.textLabel.text = [kBillTypeArray objectAtIndex:indexPath.row];
    if (indexPath.row == OrderTypeExport) {
        cell.imageView.image = [UIImage imageNamed:@"order_type_export"];
    }else if(indexPath.row == OrderTypeImport){
        cell.imageView.image = [UIImage imageNamed:@"order_type_import"];
    }else if(indexPath.row == OrderTypeSelf){
        cell.imageView.image = [UIImage imageNamed:@"order_type_self"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BillApplyViewController *billApplyVC;
    if (indexPath.row == OrderTypeExport) {
        billApplyVC = [[BillExportApplyViewController alloc]initWithCompany:self.company];
    }else if(indexPath.row == OrderTypeImport){
        billApplyVC = [[BillImportApplyViewController alloc]initWithCompany:self.company];
    }else if(indexPath.row == OrderTypeSelf){
        billApplyVC = [[BillSelfApplyViewController alloc]initWithCompany:self.company];
    }
    [self.navigationController pushViewController:billApplyVC animated:YES];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
