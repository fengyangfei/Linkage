//
//  VCFavorViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorViewController.h"
#import "VCFavor.h"
#import "VCFavorCell.h"
#import "VCFavorUtil.h"
#import "VCFavorFormDataSource.h"
#import "UIViewController+WebBrowser.h"

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupData:nil];

    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
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
        row.action.formSelector = @selector(gotoWebBrowser:);
        [section addFormRow:row];
    }
    return form;
}

#pragma mark - 事件
-(void)gotoWebBrowser:(XLFormRowDescriptor *)row
{
    VCFavor *favor = row.value;
    if (StringIsNotEmpty(favor.url)) {
        [self presentWebBrowser:favor.url];
    }
}

-(void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (!indexPath) {
            return;
        }
        NSLog(@"长按第%ld",indexPath.row);
    }
        
}
#pragma mark - helper
-(void)performFormSelector:(SEL)selector withObject:(id)sender
{
    UIResponder * responder = [self targetForAction:selector withSender:sender];;
    if (responder) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
        [responder performSelector:selector withObject:sender];
#pragma GCC diagnostic pop
    }
}

#pragma mark - 属性
-(UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, IPHONE_WIDTH, self.view.bounds.size.height- 64);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
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
