//
//  VCHotChildViewController.m
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCHotChildViewController.h"
#import "VCRankUtil.h"
#import "VcodeUtil.h"
#import "VCRankTableCell.h"
#import "VCCategoryUtil.h"
#import "VCCategory.h"
#import <MJRefresh/MJRefresh.h>

@interface VCHotChildViewController ()
@property(assign, nonatomic)NSInteger index;
@end

@implementation VCHotChildViewController
@synthesize tableView = _tableView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)setupNavigationItem
{
}

#pragma mark - 重写父类 setupData与queryDataFromServer
- (void)setupData:(void(^)(NSArray *models))completion
{
    
}

- (void)queryDataFromServer:(void(^)(void))block
{
    [self refreshTable:self.index];
}

#pragma mark - ZJScrollPageViewChildVcDelegate
- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    self.index = index;
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    //index 从1 开始
    self.index = index;
    [self.tableView.mj_header beginRefreshing];
}

//刷新列表
-(void)refreshTable:(NSInteger)index{
    VCCategory *category = [VCCategoryUtil getModelByIndex:index];
    NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"categoryCode":category.code};
    @weakify(self);
    [VCRankUtil queryCategoryRank:parameter completion:^(NSArray *models) {
        @strongify(self);
        [self initializeForm:models];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (id model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:VCRankDescriporType];
        row.value = model;
        [section addFormRow:row];
    }
    
    [self setForm:form];
}

//重写父类方法
#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

@end
