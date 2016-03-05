//
//  BillViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillViewController.h"
#import "TodoDataSource.h"
#import "DoneDataSource.h"

@interface BillViewController ()
@property (nonatomic, strong) TodoDataSource *todoDS;
@property (nonatomic, strong) DoneDataSource *doneDS;

@end

@implementation BillViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
}

-(void)setupData
{
    self.todoDS = [[TodoDataSource alloc]init];
    self.doneDS = [[DoneDataSource alloc]init];
    [self refreshData];
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

@end