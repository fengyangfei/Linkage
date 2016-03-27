//
//  BillViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillViewController.h"
#import "BillTableViewCell.h"
#import "BillDataSource.h"
#import "BillTypeViewController.h"

#import "BillApplyViewController.h"

@interface BillViewController ()<BillDataSourceDelegate>

@property (nonatomic, strong) TodoDataSource *todoDS;
@property (nonatomic, strong) DoneDataSource *doneDS;
@end

@implementation BillViewController

-(void)dealloc
{
    self.todoDS = nil;
    self.doneDS = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBillApplyViewController)];
    [self setupData];
}

-(void)setupData
{
    [self refreshTodoTable];
    [self refreshDoneTable];
}

-(void)refreshTodoTable
{
    self.todoDS = [[TodoDataSource alloc]init];
    [self.todoDS setForm:[self createForm]];
    self.todoDS.dataSourceDelegate = self;
    self.todoTableView.dataSource = self.todoDS;
    self.todoTableView.delegate = self.todoDS;
    if ([self isViewLoaded]){
        [self.todoTableView reloadData];
    }
}

-(void)refreshDoneTable
{
    self.doneDS = [[DoneDataSource alloc]init];
    [self.doneDS setForm:[self createForm]];
    self.doneDS.dataSourceDelegate = self;
    self.doneTableView.dataSource = self.doneDS;
    self.doneTableView.delegate = self.doneDS;
    if ([self isViewLoaded]){
        [self.doneTableView reloadData];
    }
}

-(void)pushBillApplyViewController
{
    BillTypeViewController *controller = [[BillTypeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - BillDataSourceDelegate
-(UIViewController *)formControllerOfDataSource:(BillDataSource*)dataSource
{
    return self;
}


-(XLFormDescriptor *)createForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (int i = 0; i < 10; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:TodoBillDescriporType];
        row.action.viewControllerClass = [BillExportApplyViewController class];
        [section addFormRow:row];
    }
    
    return form;
}

@end