//
//  SearchCompanyViewController.m
//  Linkage
//
//  Created by Mac mini on 16/8/16.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SearchCompanyViewController.h"
#import "Company.h"
#import "CompanyUtil.h"
#import "MainTableViewCell.h"
#import "CompanyInfoViewController.h"
#import "LoginUser.h"

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
@interface SearchCompanyViewController()<UISearchBarDelegate>
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchKey;
@end

@implementation SearchCompanyViewController
@synthesize searchBar = _searchBar;

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *historys = [LoginUser searchCompanyKeys];
        self.form = [self createHistoryForm:historys];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 14)];
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
    NSString *title = [NSString stringWithFormat:@"搜索结果(共%lu条)", (unsigned long)results.count];
    section = [XLFormSectionDescriptor formSectionWithTitle:title];
    [form addFormSection:section];
    
    NSString *rowType = CompanyInfoDescriporType;
    LoginUser *user = [LoginUser shareInstance];
    if (user.ctype == UserTypeCompanyAdmin || user.ctype == UserTypeCompanyUser) {
        rowType = CompanyDescriporType;
    }else if(user.ctype == UserTypeSubCompanyAdmin) {
        rowType = CompanyInfoDescriporType;
    }
    for (Company *model in results) {
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:rowType];
        row.value = model;
        row.action.viewControllerClass = [CompanyInfoViewController class];
        [section addFormRow:row];
    }
    return form;
}

#pragma mark - 事件
-(void)clearHistorys:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [LoginUser setsearchCompanyKeys:nil];
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
    NSArray *keys = [LoginUser searchCompanyKeys];
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
    [LoginUser setsearchCompanyKeys:[mutableKeys copy]];
}

-(void)searchFromServer
{
    WeakSelf
    NSDictionary *parameter = @{
                                @"name":self.searchKey
                                };
    parameter = [[LoginUser shareInstance].basePageHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [CompanyUtil queryModelsFromServer:parameter url:SearchCompanyUrl completion:^(NSArray *models) {
        XLFormDescriptor *form = [weakSelf createResultForm:models];
        [weakSelf setForm:form];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchKey = searchText;
    if (StringIsEmpty(searchText)) {
        NSArray *keys = [LoginUser searchCompanyKeys];
        [self setForm:[self createHistoryForm:keys]];
    }
}

//键盘的搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchAction];
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
        _searchBar.placeholder = @"请搜索关键字";
    }
    return _searchBar;
}

@end
