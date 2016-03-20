//
//  BillViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillViewController.h"
#import "BillDataSource.h"
#import "TRPopButton.h"

#import "BillApplyViewController.h"

@interface BillViewController ()
@property (nonatomic, readonly) UIButton *addButton;

@property (nonatomic, strong) TodoDataSource *todoDS;
@property (nonatomic, strong) DoneDataSource *doneDS;
@end

@implementation BillViewController
@synthesize addButton = _addButton;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    [self setupData];
}

-(void)setupData
{
    self.todoDS = [[TodoDataSource alloc]init];
    self.doneDS = [[DoneDataSource alloc]init];
    [self refreshData];
}

-(void)configureUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushBillApplyViewController)];
}

-(void)refreshData
{
    self.todoTableView.dataSource = self.todoDS;
    self.todoTableView.delegate = self.todoDS;
    self.doneTableView.dataSource = self.doneDS;
    self.doneTableView.delegate = self.doneDS;
    [self.todoTableView reloadData];
    [self.doneTableView reloadData];
}

//切换segment
- (void)segmentedControlChangeIndex:(NSInteger)index
{
    
}

-(void)pushBillApplyViewController
{
    BillExportApplyViewController *exportApplyVC = [[BillExportApplyViewController alloc]init];
    [self.navigationController pushViewController:exportApplyVC animated:YES];
}

#pragma mark - 属性
-(UIButton *)addButton
{
    WeakSelf
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.layer.masksToBounds = YES;
        _addButton.layer.cornerRadius = 25.0;
        _addButton.backgroundColor = ButtonColor;
        [_addButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
        [_addButton bk_addEventHandler:^(id sender) {
            [weakSelf pushBillApplyViewController];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end