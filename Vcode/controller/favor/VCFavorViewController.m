//
//  VCFavorViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorViewController.h"
#import "VCFavorCell.h"
#import "VCFavorUtil.h"
#import "VCFavorFormDataSource.h"

@interface VCFavorViewController ()
@property (nonatomic, readonly) UITableView           *tableView;
@property (nonatomic, strong  ) VCFavorFormDataSource *dataSource;
@end

@implementation VCFavorViewController
@synthesize tableView = _tableView;

-(void)setupUI
{
    [super setupUI];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    [self setupData:nil];
}

- (void)setupData:(void(^)(NSArray *models))completion
{
    @weakify(self);
    [VCFavorUtil queryModelsFromDataBase:^(NSArray *models) {
        @strongify(self);
        XLFormDescriptor *form = [self initializeForm:models];
        [self.dataSource setForm:form];
        if (completion) {
            completion(models);
        }
    }];
}

- (XLFormDescriptor *)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (id model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:VCFavorDescriporType];
        row.value = model;
        [section addFormRow:row];
    }
    return form;
}

#pragma mark - 属性
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.sectionFooterHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    return _tableView;
}

-(VCFavorFormDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[VCFavorFormDataSource alloc] initWithViewController:self tableView:self.tableView];
    }
    return _dataSource;
}

@end
