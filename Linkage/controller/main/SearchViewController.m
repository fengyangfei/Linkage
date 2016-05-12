//
//  SearchViewController.m
//  Linkage
//
//  Created by lihaijian on 16/5/11.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SearchViewController.h"
#import "Order.h"
#import "OrderUtil.h"
#import "OrderCell.h"
#import "BillDetailViewController.h"
#import "LoginUser.h"

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
@interface SearchViewController()<UISearchBarDelegate>
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchKey;
@end

@implementation SearchViewController
@synthesize searchBar = _searchBar;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
    @weakify(self);
    RAC(self.navigationItem, rightBarButtonItem) = [[RACObserve(self, searchKey) distinctUntilChanged] map:^id(NSString *key) {
        @strongify(self);
        if (key.length > 0) {
            return [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
        }else{
            return nil;
        }
    }];
    NSArray *historys = [LoginUser searchKeys];
    [self setForm:[self createHistoryForm:historys]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

-(XLFormDescriptor *)createHistoryForm:(NSArray *)historys
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    if (historys && historys.count > 0) {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"历史记录"];
        [form addFormSection:section];
        
        for (NSString *key in historys) {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:key];
            RowUI
            row.value = key;
            row.action.formSelector = @selector(searchWithKey:);
            [section addFormRow:row];
        }
        
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"清除历史记录"];
        row.action.formSelector = @selector(clearHistorys:);
        [section addFormRow:row];
    }
    
    return form;
}

-(XLFormDescriptor *)createResultForm:(NSArray *)results
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (Order *order in results) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:PendingOrderDescriporType];
        row.value = order;
        row.action.viewControllerClass = [BillDetailViewController class];
        [section addFormRow:row];
    }
    return form;
}

#pragma mark - 事件
-(void)clearHistorys:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [LoginUser setsearchKeys:nil];
    [self setForm:[self createHistoryForm:nil]];
}

-(void)searchWithKey:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    if ([row.value isKindOfClass:[NSString class]]) {
        self.searchKey = row.value;
        self.searchBar.text = row.value;
    }
    [self searchAction];
}

-(void)searchAction
{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    [self saveHistoryKey];
    [self searchFromServer];
}

-(void)saveHistoryKey
{
    NSArray *keys = [LoginUser searchKeys];
    NSMutableArray *mutableKeys;
    if (!keys) {
        mutableKeys = [NSMutableArray array];
    }else{
        mutableKeys = [keys mutableCopy];
    }
    if (self.searchKey) {
        if (![mutableKeys containsObject:self.searchKey]) {
            [mutableKeys addObject:self.searchKey];
        }
    }
    [LoginUser setsearchKeys:[mutableKeys copy]];
}

-(void)searchFromServer
{
    WeakSelf
    NSDictionary *parameter = @{
                                @"type":@(-1),
                                @"status":@(0)
                                };
    parameter = [[LoginUser shareInstance].basePageHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [OrderUtil queryModelsFromServer:parameter url:ListByStatusUrl completion:^(NSArray *orders) {
        XLFormDescriptor *form = [weakSelf createResultForm:orders];
        [weakSelf setForm:form];
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchKey = searchText;
    if (StringIsEmpty(searchText)) {
        NSArray *keys = [LoginUser searchKeys];
        [self setForm:[self createHistoryForm:keys]];
    }
}

#pragma mark - 属性
-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.translucent = YES;
        _searchBar.delegate = self;
        _searchBar.backgroundColor = HeaderColor;
        _searchBar.tintColor = HeaderColor;
        _searchBar.placeholder = @"请输入订单信息";
    }
    return _searchBar;
}

@end
