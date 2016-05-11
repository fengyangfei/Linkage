//
//  SearchViewController.m
//  Linkage
//
//  Created by lihaijian on 16/5/11.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController()
@property (nonatomic, readonly) UISearchBar *searchBar;

@end

@implementation SearchViewController
@synthesize searchBar = _searchBar;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleBordered target:self action:@selector(searchAction:)];
}

-(XLFormDescriptor *)createForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    return form;
}

-(void)searchAction:(id)sender
{

}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.translucent = YES;
        _searchBar.placeholder = @"请输入订单信息";
    }
    return _searchBar;
}

@end
