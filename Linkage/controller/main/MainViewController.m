//
//  MainViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MainViewController.h"
#import "MainDataSource.h"

@interface MainViewController ()
@property (nonatomic, strong) MainDataSource *dataSource;

@end

@implementation MainViewController

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
