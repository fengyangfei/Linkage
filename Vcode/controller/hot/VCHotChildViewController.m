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

@interface VCHotChildViewController ()
@property(assign, nonatomic)NSInteger index;

@end

@implementation VCHotChildViewController
@synthesize tableView = _tableView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(Class)modelUtilClass
{
    return [VCRankUtil class];
}

-(void)setupNavigationItem
{
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
    
    self.form = form;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

#pragma mark - ZJScrollPageViewChildVcDelegate
- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    //index 从1 开始
    self.index = index;
    
    NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"categoryCode":@"Arts"};
    [VCRankUtil queryCategoryRank:parameter completion:^(NSArray *models) {
        
    }];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
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

@end
