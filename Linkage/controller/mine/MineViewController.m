//
//  MineViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MineViewController.h"
#import "MenuTableViewCell.h"
#import "MenuItem.h"

#import "SettingViewController.h"

#define isFirstRow (indexPath.section == 0 && indexPath.row == 0)
#define kMenuTableViewCellIndentifier @"kMenuTableViewCellIndentifier"
#define kMenuHeaderTableViewCellIndentifier @"kMenuHeaderTableViewCellIndentifier"
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *array;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
}

-(void)setupData
{
    self.array = [MenuItem menuItemsFromTheme];
}

-(void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.view.bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(MenuItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.array[indexPath.section];
    MenuItem *item = [array objectAtIndex:indexPath.row];
    return item;
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.array[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = isFirstRow?kMenuHeaderTableViewCellIndentifier:kMenuTableViewCellIndentifier;
    MenuBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    [cell updateUI:[self itemForIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell cellDidSelectedWithController:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isFirstRow) {
        return 80;
    }
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

#pragma mark - 属性
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:kMenuTableViewCellIndentifier];
        [_tableView registerClass:[MenuHeaderTableViewCell class] forCellReuseIdentifier:kMenuHeaderTableViewCellIndentifier];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
