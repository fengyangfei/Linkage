//
//  FormOptionsViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FormOptionsViewController.h"
#import "LoginUser.h"
#import "Company.h"
#import "MJRefresh.h"

@interface FormOptionsViewController ()
@end

@implementation FormOptionsViewController
@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.rowDescriptor.title;
    [self setupUI];
    [self getDataFromLocal];
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

-(void)reloadData
{
    [self.tableView reloadData];
}

-(void)getDataFromLocal
{
    //本地数据
}

-(void)getDataFromServer
{
    //服务端数据
}

-(void)generateOptions:(NSArray *)arrays
{
    //生成Options
}

-(void)selectOption:(id<XLFormOptionObject>)option
{
    //选择选项
}

#pragma mark -UITableView delegate&&datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    id<XLFormOptionObject> option = [self.options objectAtIndex:indexPath.row];
    cell.textLabel.text = [option formDisplayText];
    cell.textLabel.textColor = IndexTitleFontColor;
    if ([[self.rowDescriptor.value valueData] isEqual:[option formValue]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id<XLFormOptionObject> option = [self.options objectAtIndex:indexPath.row];
    [self selectOption:option];
    if (self.rowDescriptor.value){
        NSInteger index = [self.options formIndexForItem:self.rowDescriptor.value];
        if (index != NSNotFound){
            NSIndexPath * oldSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:oldSelectedIndexPath];
            oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    self.rowDescriptor.value = option;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end

@implementation CompanyOptionsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.options = [LoginUser shareInstance].companies;
    }
    return self;
}
@end
