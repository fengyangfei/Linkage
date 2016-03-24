//
//  FavoriteViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/24.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FavoriteViewController.h"
#import "MainDataSource.h"
@interface FavoriteViewController ()
@property (nonatomic, strong) MainDataSource *dataSource;

@end

@implementation FavoriteViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self setupUI];
    [self setupData];
}

-(void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)setupData
{
    self.dataSource = [[CompanyDataSource alloc]init];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
