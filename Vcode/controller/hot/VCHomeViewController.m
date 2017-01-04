//
//  VCHomeViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCHomeViewController.h"
#import "SDCycleScrollView.h"

@interface VCHomeViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic, readonly) SDCycleScrollView *scrollView;

@end

@implementation VCHomeViewController
@synthesize scrollView = _scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)setupUI
{
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter setter
-(SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        CGRect rect = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH / 3);
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _scrollView.delegate = self;
    }
    return _scrollView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

@end
