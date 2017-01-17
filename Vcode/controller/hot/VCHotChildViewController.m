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
#import "MMAlertView.h"
#import "VCPageUtil.h"
#import "VCIndex.h"
#import "UIViewController+WebBrowser.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface VCHotChildViewController ()
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, assign) RankType rankType;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *rows;
@end

@implementation VCHotChildViewController
@synthesize tableView = _tableView;
@synthesize rows = _rows;

-(instancetype)initWithRankType:(RankType)rankType
{
    self = [super init];
    if (self) {
        self.rankType = rankType;
        self.currentPage = 1;
    }
    return self;
}

-(void)setupUI
{
    @weakify(self);
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView setEditing:NO];
    void(^headerLoadSuccess)(void) = ^() {
        @strongify(self);
        if([self.tableView.mj_header isRefreshing]){
            [self.tableView.mj_header endRefreshing];
        }
    };
    void(^footerLoadSuccess)(void) = ^() {
        @strongify(self);
        if([self.tableView.mj_footer isRefreshing]){
            [self.tableView.mj_footer endRefreshing];
        }
    };
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage = 1;
        [self queryDataFromServer:headerLoadSuccess];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage += 1;
        [self queryDataFromServer:footerLoadSuccess];
    }];
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
    
    [self setupNavigationItem];
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
    [self refreshTable:block];
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
-(void)refreshTable:(void(^)(void))completion{
    @weakify(self);
    void(^success)(NSArray *models) = ^(NSArray *models) {
        @strongify(self);
        [self initializeForm:models];
        if (completion) {
            completion();
        }
    };
    void(^failure)(NSError *error) = ^(NSError *error) {
        if (completion) {
            completion();
        }
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    };
    if (self.rankType == RankTypeCategory) {
        [VCCategoryUtil getModelByTitle:self.title completion:^(VCCategory *model) {
            @strongify(self);
            NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"categoryCode":model.code,@"page":@(self.currentPage)};
            [VCRankUtil queryCategoryRank:parameter completion:^(NSArray *models) {
                success(models);
            } failure:failure];
        }];
    }
    else if (self.rankType == RankTypeLocal){
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"countryCode":self.title?:@"CN",@"page":@(self.currentPage)};
        [VCRankUtil queryLocalRank:parameter completion:^(NSArray *models) {
            success(models);
        } failure:failure];
    }
    else if (self.rankType == RankTypeRecommend){
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"page":@(self.currentPage)};
        [VCRankUtil queryRecommendRank:parameter completion:^(NSArray *models) {
            success(models);
        } failure:failure];
    }
    else if (self.rankType == RankTypeHot){
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"page":@(self.currentPage)};
        [VCRankUtil queryHotRank:parameter completion:^(NSArray *models) {
            success(models);
        } failure:failure];
    }
    else if (self.rankType == RankTypeGlobal){
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"page":@(self.currentPage)};
        [VCRankUtil queryGlobalRank:parameter completion:^(NSArray *models) {
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
    
    if (self.currentPage == 1) {
        [self.rows removeAllObjects];
    }
    [self.rows addObjectsFromArray:models];
    for (id model in self.rows) {
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
    //同步添加访问记录
    NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID], @"url": rank.url};
    [[YGRestClient sharedInstance] postForObjectWithUrl:AddVisitRecordUrl form:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [self presentWebBrowser:rank.url];
}

-(void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (!indexPath) {
            return;
        }
        VCRank *rank = [self.rows objectAtIndex:indexPath.row];
        @weakify(rank);
        MMPopupItemHandler block = ^(NSInteger index){
            @strongify(rank);
            VCPage *page = [[VCPage alloc]init];
            page.name = rank.name;
            page.url = rank.url;
            page.sortNumber = @(-1);
            [VCPageUtil syncToDataBase:page completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kPageUpdateNotification object:nil];
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            }];
        };
        NSMutableArray *items = [[NSMutableArray alloc]init];
        [items addObject:MMItemMake(VCThemeString(@"cancel"), MMItemTypeNormal, nil)];
        [items addObject:MMItemMake(VCThemeString(@"ok"), MMItemTypeNormal, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"添加标签页"
                                                             detail:@""
                                                              items:items];
        alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
        alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
        [alertView show];
    }
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


#pragma mark - getter setter
-(UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, IPHONE_WIDTH, self.view.bounds.size.height- 48);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

-(NSMutableArray *)rows
{
    if (!_rows) {
        _rows = [[NSMutableArray alloc]init];
    }
    return _rows;
}

@end
