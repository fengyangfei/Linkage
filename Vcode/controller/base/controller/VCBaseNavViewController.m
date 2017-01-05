//
//  VCBaseNavViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCBaseNavViewController.h"

@interface VCBaseNavViewController ()<UISearchBarDelegate>
@property (nonatomic, readonly) UIButton *brandBtn;
@property (nonatomic, readonly) UISearchBar *searchBar;
@end

@implementation VCBaseNavViewController
@synthesize brandBtn = _brandBtn;
@synthesize searchBar = _searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.brandBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *centerItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = centerItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.searchBar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if ([self.searchBar isFirstResponder]) {
//        [self.searchBar resignFirstResponder];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (StringIsEmpty(searchText)) {
    }
}

//键盘的搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
}

-(void)changeBrand:(id)sender
{

}

#pragma mark - 属性
-(UIButton *)brandBtn
{
    if (!_brandBtn) {
        _brandBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
        [_brandBtn setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
        [_brandBtn addTarget:self action:@selector(changeBrand:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _brandBtn;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 80, 44)];
        _searchBar.barStyle = UIBarStyleBlack;
        _searchBar.tintColor = [UIColor blackColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入搜索文字";
    }
    return _searchBar;
}


@end
