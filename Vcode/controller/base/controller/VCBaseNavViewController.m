//
//  VCBaseNavViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCBaseNavViewController.h"
#import "FTPopOverMenu.h"
#import "UIViewController+WebBrowser.h"
#import "VcodeUtil.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kVCCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * VCPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kVCCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@interface VCBaseNavViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, readonly) UIButton *brandBtn;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) UIButton *searchBtn;
@property (nonatomic, copy    ) NSString *searchKey;
@property (nonatomic, strong  ) NSNumber *engine;
@property (nonatomic, strong)   UIView * backgroundView;
@end

@implementation VCBaseNavViewController
@synthesize brandBtn = _brandBtn;
@synthesize searchBar = _searchBar;
@synthesize searchBtn = _searchBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindViewModel];
}

-(void)bindViewModel
{
    RACSignal *single = RACObserve(self, engine);
    @weakify(self);
    [single subscribeNext:^(id x) {
        [[NSUserDefaults standardUserDefaults] setObject:x forKey:kSearchEngineUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];

    RACChannelTerminal *channel = [[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:kSearchEngineUserDefaultKey];
    [channel subscribeNext:^(id x) {
        @strongify(self);
        NSString *imgedName = [VcodeUtil searchImage:[x integerValue]];
        UIImage *image = [UIImage imageNamed:imgedName];
        [self.brandBtn setImage:image forState:UIControlStateNormal];
        self.brandBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber *defalutValue = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchEngineUserDefaultKey];
    if (defalutValue) {
        self.engine = defalutValue;
    }
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
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([self.engine integerValue] == SearchEngineHttp) {
        searchBar.placeholder = @"请输入网址";
    }else{
        searchBar.placeholder = @"搜索您感兴趣的内容";
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.backgroundView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.placeholder = @"IPv6.Vcode";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchKey = searchText;
}

#pragma mark - 事件
//键盘的搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchAction:nil];
}

-(void)changeBrand:(id)sender
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.textColor = [UIColor blackColor];
    configuration.textFont = [UIFont boldSystemFontOfSize:14];
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor lightGrayColor];
    configuration.borderWidth = 0.5;
    
    NSArray *array = @[@(SearchEngineGoogle),@(SearchEngineBaidu),@(SearchEngineBing),@(SearchEngineYahoo),@(SearchEngineHttp)];
    
    NSMutableArray *imageArray;
    imageArray = [[NSMutableArray alloc]init];
    for (id key in array) {
        [imageArray addObject:[VcodeUtil searchImage:[key integerValue]]];
    }
    @weakify(self);
    [FTPopOverMenu showForSender:sender
                      imageArray:imageArray
                       doneBlock:^(NSInteger selectedIndex) {
                           @strongify(self);
                           self.engine = [array objectAtIndex:selectedIndex];
    }
                    dismissBlock:^{
        
    }];
}

-(void)searchAction:(id)sender
{
    [self.backgroundView removeFromSuperview];
    NSNumber *key = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchEngineUserDefaultKey];
    NSString *value = VCPercentEscapedQueryStringValueFromStringWithEncoding(self.searchKey, NSUTF8StringEncoding);
    NSString *url = [NSString stringWithFormat:@"%@%@",[VcodeUtil searchUrl:[key integerValue]], value];
    [self presentWebBrowser:url];
}

#pragma mark - onBackgroundViewTapped

-(void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture
{
    BOOL finished = [self.searchBar resignFirstResponder];
    if (finished) {
        [self.backgroundView removeFromSuperview];
    }
}

#pragma mark - 属性
-(UIButton *)brandBtn
{
    if (!_brandBtn) {
        _brandBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
        //小箭头
        UIImageView *downView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down"]];
        [downView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_brandBtn addSubview:downView];
        [_brandBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(10)]|" options:0 metrics:0 views:@{@"image": downView}]];
        [_brandBtn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[image(10)]" options:0 metrics:0 views:@{@"image": downView}]];
        [_brandBtn addConstraint:[NSLayoutConstraint constraintWithItem:downView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_brandBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        _brandBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);

        //设置搜索引擎图标
//        UIImage *image = [UIImage imageNamed:@"google"];
//        [self.brandBtn setImage:image forState:UIControlStateNormal];
        [_brandBtn addTarget:self action:@selector(changeBrand:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _brandBtn;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 145, 44)];
        _searchBar.barStyle = UIBarStyleBlack;
        _searchBar.translucent = YES;
        _searchBar.tintColor = [UIColor blackColor];
        _searchBar.barTintColor = HEXCOLOR(0xe0e0e0);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"IPv6.Vcode";
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

-(UIView *)backgroundView
{
    if (!_backgroundView) {
        CGRect frame = CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_HEIGHT - 64);
        _backgroundView = [[UIView alloc ]initWithFrame:frame];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.backgroundColor = [UIColor clearColor];
        //_backgroundView.backgroundColor = [UIColor redColor];
    }
    return _backgroundView;
}


@end
