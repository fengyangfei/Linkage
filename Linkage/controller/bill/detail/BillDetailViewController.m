//
//  BillDetailViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillDetailViewController.h"
#import "XLFormDataSource.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "DriverInfoCell.h"

@interface BillDetailViewController()
@property (nonatomic, strong) XLFormDataSource *detailDS;
@property (nonatomic, strong) XLFormDataSource *historyDS;

@end

@implementation BillDetailViewController
-(void)dealloc
{
    self.detailDS = nil;
    self.historyDS = nil;
    self.leftTableView.delegate = nil;
    self.rightTableView.dataSource = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setupData];
}

-(void)setupData
{
    [self refreshLeftTable];
    [self refreshRightTable];
}

-(void)refreshLeftTable
{
    self.detailDS = [[XLFormDataSource alloc]initWithViewController:self tableView:self.leftTableView];
    [self.detailDS setForm:[self createDetailForm]];
    self.leftTableView.dataSource = self.detailDS;
    self.leftTableView.delegate = self.detailDS;
    if ([self isViewLoaded]){
        [self.leftTableView reloadData];
    }
}

-(void)refreshRightTable
{
    self.historyDS = [[XLFormDataSource alloc]initWithViewController:self tableView:self.rightTableView];
    [self.historyDS setForm:[self createHistoryForm]];
    self.rightTableView.dataSource = self.historyDS;
    self.rightTableView.delegate = self.historyDS;
    if ([self isViewLoaded]){
        [self.rightTableView reloadData];
    }
}

-(XLFormDescriptor *)createDetailForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"测试"];
        row.value = @(i);
        [section addFormRow:row];
    }
    
    return form;
}

-(XLFormDescriptor *)createHistoryForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"货柜A"];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverInfoDescriporType];
        row.value = @(i);
        [section addFormRow:row];
    }
    
    return form;
}

#pragma mark - 重写
- (HMSegmentedControl *)segmentedControl
{
    HMSegmentedControl *segmentedControl = [super segmentedControl];
    segmentedControl.sectionTitles = @[@"订单进度", @"订单详情"];
    return segmentedControl;
}

@end
