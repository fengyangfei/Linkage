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
#import "VCRank.h"
#import "UIViewController+WebBrowser.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface VCHotChildViewController ()
@property(assign, nonatomic)NSInteger index;
@property (nonatomic, assign) RankType rankType;
@end

@implementation VCHotChildViewController
@synthesize tableView = _tableView;

-(instancetype)initWithRankType:(RankType)rankType
{
    self = [super init];
    if (self) {
        self.rankType = rankType;
    }
    return self;
}

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
    [self.tableView.mj_header beginRefreshing];
}

- (void)queryDataFromServer:(void(^)(void))block
{
    [self refreshTable];
}

#pragma mark - ZJScrollPageViewChildVcDelegate
- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    self.index = index;
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    //index 从1 开始
    self.index = index;
}

//刷新列表
-(void)refreshTable{
    @weakify(self);
    void(^success)(NSArray *models) = ^(NSArray *models) {
        @strongify(self);
        [self initializeForm:models];
        [self.tableView.mj_header endRefreshing];
    };
    void(^failure)(NSError *error) = ^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    };
    if (self.rankType == RankTypeCategory) {
        [VCCategoryUtil getModelByTitle:self.title completion:^(VCCategory *model) {
            NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"categoryCode":model.code};
            [VCRankUtil queryCategoryRank:parameter completion:^(NSArray *models) {
                success(models);
            } failure:failure];
        }];
    }
    else if (self.rankType == RankTypeLocal){
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"countryCode":self.title?:@"CN"};
        [VCRankUtil queryLocalRank:parameter completion:^(NSArray *models) {
            success(models);
        } failure:failure];
    }
    else if (self.rankType == RankTypeRecommend){
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID]};
        [VCRankUtil queryRecommendRank:parameter completion:^(NSArray *models) {
            success(models);
        } failure:failure];
    }
    else if (self.rankType == RankTypeHot){
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID]};
        [VCRankUtil queryHotRank:parameter completion:^(NSArray *models) {
            success(models);
        } failure:failure];
    }
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
        row.action.formSelector = @selector(gotoWebBrowser:);
        [section addFormRow:row];
    }
    
    [self setForm:form];
}

-(void)gotoWebBrowser:(XLFormRowDescriptor *)row
{
    VCRank *rank = row.value;
    [self presentWebBrowser:rank.url];
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
        CGRect frame = CGRectMake(0, 0, IPHONE_WIDTH, self.view.bounds.size.height- 48);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

@end
