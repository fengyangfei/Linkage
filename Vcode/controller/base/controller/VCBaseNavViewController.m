//
//  VCBaseNavViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCBaseNavViewController.h"
#import "FTPopOverMenu.h"

@interface VCBaseNavViewController ()<UISearchBarDelegate>
@property (nonatomic, readonly) UIButton *brandBtn;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) UIButton *searchBtn;
@property (nonatomic, copy) NSString *engineStr;
@end

@implementation VCBaseNavViewController
@synthesize brandBtn = _brandBtn;
@synthesize searchBar = _searchBar;
@synthesize searchBtn = _searchBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self bindViewModel];
}

-(void)setupData
{
    self.engineStr = @"google";
}

-(void)bindViewModel
{
    RACSignal *single = RACObserve(self, engineStr);
    @weakify(self);
    [single subscribeNext:^(id x) {
        @strongify(self);
        UIImage *image = [UIImage imageNamed:x];
        [self.brandBtn setImage:image forState:UIControlStateNormal];
    }];
}

-(void)setupUI
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -10;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.brandBtn];
    self.navigationItem.leftBarButtonItems = @[fixedSpace, leftItem];
    
    UIBarButtonItem *centerItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItems = @[fixedSpace, searchItem,centerItem];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.textColor = [UIColor blackColor];
    configuration.textFont = [UIFont boldSystemFontOfSize:14];
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor clearColor];
    configuration.borderWidth = 0.5;
    
    NSArray *array = @[@"baidu",@"google", @"bing"];
    @weakify(self);
    [FTPopOverMenu showForSender:sender
                   withMenuArray:array
                      imageArray:array
                       doneBlock:^(NSInteger selectedIndex) {
                           @strongify(self);
                           self.engineStr = [array objectAtIndex:selectedIndex];
    }
                    dismissBlock:^{
        
    }];
}

-(void)searchAction:(id)sender
{

}

#pragma mark - 属性
-(UIButton *)brandBtn
{
    if (!_brandBtn) {
        _brandBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        //小箭头
        UIImageView *downView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down"]];
        [downView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_brandBtn addSubview:downView];
        [_brandBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(10)]|" options:0 metrics:0 views:@{@"image": downView}]];
        [_brandBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[image(10)]" options:0 metrics:0 views:@{@"image": downView}]];
        [_brandBtn addConstraint:[NSLayoutConstraint constraintWithItem:downView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_brandBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        _brandBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);

        //设置搜索引擎图标
        [_brandBtn addTarget:self action:@selector(changeBrand:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _brandBtn;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 145, 44)];
        _searchBar.barStyle = UIBarStyleBlack;
        _searchBar.tintColor = [UIColor redColor];
        _searchBar.barTintColor = HEXCOLOR(0xe0e0e0);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入搜索文字";
    }
    return _searchBar;
}

-(UIButton *)searchBtn
{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
        UIImage *image = [UIImage imageNamed:@"search"];
        [_searchBtn setImage:image forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;

}


@end
