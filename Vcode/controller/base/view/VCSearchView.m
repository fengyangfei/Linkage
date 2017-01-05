//
//  VCSearchView.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCSearchView.h"
@interface VCSearchView()<UISearchBarDelegate>
@property (nonatomic,readonly) UIButton *brandBtn;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchKey;
@end

@implementation VCSearchView
@synthesize brandBtn = _brandBtn;
@synthesize searchBar = _searchBar;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.brandBtn];
    [self addSubview:self.searchBar];
}

#pragma mark - getter setter
-(UIButton *)brandBtn
{
    if (!_brandBtn) {
        _brandBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [_brandBtn setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
    }
    return _brandBtn;
}

#pragma mark - 属性
-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(80, 0, IPHONE_WIDTH - 80, 44)];
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.translucent = YES;
        _searchBar.delegate = self;
        _searchBar.backgroundColor = VHeaderColor;
        _searchBar.tintColor = VHeaderColor;
        _searchBar.placeholder = @"search info you want";
    }
    return _searchBar;
}

@end
