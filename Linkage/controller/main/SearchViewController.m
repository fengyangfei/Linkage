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
            return [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
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
    WeakSelf
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    [self saveHistoryKey];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"搜索条件" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *billAction = [UIAlertAction actionWithTitle:@"订单号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf searchFromServerWithType:@(0)];
    }];
    UIAlertAction *cargoAction = [UIAlertAction actionWithTitle:@"柜号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf searchFromServerWithType:@(1)];
    }];
    UIAlertAction *carAction = [UIAlertAction actionWithTitle:@"车牌" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf searchFromServerWithType:@(2)];
    }];
    UIAlertAction *beginDateAction = [UIAlertAction actionWithTitle:@"开始结束日期" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf searchFromServerWithType:@(3)];
    }];
    UIAlertAction *subCompanyAction = [UIAlertAction actionWithTitle:@"厂商名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf searchFromServerWithType:@(4)];
    }];
    UIAlertAction *companyAction = [UIAlertAction actionWithTitle:@"承运商名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf searchFromServerWithType:@(5)];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:billAction];
    [alertController addAction:cargoAction];
    [alertController addAction:carAction];
    [alertController addAction:beginDateAction];
    [alertController addAction:subCompanyAction];
    [alertController addAction:companyAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
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

-(void)searchFromServerWithType:(NSNumber *)searchType
{
    WeakSelf
    NSDictionary *parameter = @{
                                @"company_id":[LoginUser shareInstance].companyId,
                                @"searchType":searchType,
                                @"value":self.searchKey
                                };
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [OrderUtil queryModelsFromServer:parameter url:SearchOrderUrl completion:^(NSArray *orders) {
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
