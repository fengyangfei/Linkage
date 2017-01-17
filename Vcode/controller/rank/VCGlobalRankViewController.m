//
//  VCGlobalRankViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//
#import "VCGlobalRankViewController.h"
#import "VCRankUtil.h"
#import "VCRank.h"
#import "VCRankTableCell.h"
#import "UIViewController+WebBrowser.h"

@interface VCGlobalRankViewController ()

@end

@implementation VCGlobalRankViewController
-(instancetype)init
{
    return [super initWithRankType:RankTypeGlobal];
}

/*
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


- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    NSLog(@"%ld",(long)index);
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
    
    self.form = form;
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
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
        [row.sectionDescriptor removeFormRowAtIndex:indexPath.row];
    }
}
 */

@end
