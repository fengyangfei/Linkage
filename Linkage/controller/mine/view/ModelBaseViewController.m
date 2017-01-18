//
//  ModelBaseViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "ModelBaseViewController.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"
#import "MJRefresh.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
row.cellStyle = UITableViewCellStyleValue1;

@interface ModelBaseViewController()
@end

@implementation ModelBaseViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize controllerType = _controllerType;

- (instancetype)initWithControllerType:(ControllerType)controllerType
{
    self = [super init];
    if (self) {
        self.controllerType = controllerType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    @weakify(self);
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
    [self.tableView setEditing:NO];
    void(^headerLoadSuccess)(void) = ^() {
        @strongify(self);
        if([self.tableView.mj_footer isRefreshing]){
            [self.tableView.mj_footer endRefreshing];
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
        [self queryDataFromServer:headerLoadSuccess];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self queryDataFromServer:footerLoadSuccess];
    }];
    
    [self setupNavigationItem];
}

-(void)setupNavigationItem
{
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItems = @[editBtn, addBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WeakSelf
    [self setupData:^(NSArray *models) {
        if (models.count <= 0) {
            if (![weakSelf.tableView.mj_header isRefreshing]) {
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        }
    }];
}

- (void)queryDataFromServer:(void(^)(void))block
{
    WeakSelf
    [self.modelUtilClass queryModelsFromServer:^(NSArray *models) {
        [self.modelUtilClass truncateAll];
        for (id model in models) {
            [self.modelUtilClass syncToDataBase:model completion:nil];
        }
        StrongSelf
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
            [strongSelf setupData:nil];
        }];
        if (block) {
            block();
        }
    }];
}

- (void)setupData:(void(^)(NSArray *models))completion
{
    WeakSelf
    [self.modelUtilClass queryModelsFromDataBase:^(NSArray *models) {
        [weakSelf initializeForm:models];
        if (completion) {
            completion(models);
        }
    }];
}

- (void)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    for (id<MTLJSONSerializing,XLFormTitleOptionObject> model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:[model formTitleText]];
        RowUI
        row.value = model;
        if (self.controllerType == ControllerTypeQuery) {
            //选择行后处理事件
            row.action.formSelector = @selector(didSelectModel:);
        }else{
            //进入详情页面
            row.action.viewControllerClass = self.viewControllerClass;
        }
        [section addFormRow:row];
    }
    [self setForm:form];
}

#pragma mark - action
-(void)editAction:(UIBarButtonItem *)sender
{
    if(!self.tableView.isEditing){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editAction:)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    }
    [self.tableView setEditing:!self.tableView.isEditing];
}

-(void)addAction:(UIBarButtonItem *)sender
{
    id viewController = [[self.viewControllerClass alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
        [row.sectionDescriptor removeFormRowAtIndex:indexPath.row];
        [SVProgressHUD show];
        [self.modelUtilClass deleteFromServer:row.value success:^(id responseData) {
            StrongSelf
            [self.modelUtilClass deleteFromDataBase:row.value completion:^{
                [SVProgressHUD dismiss];
                [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
                [strongSelf setupData:nil];
            }];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

@end
