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
        // 情景二：采用网络图片实现
        NSArray *imagesURLStrings = @[
                                      @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                      @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                      ];
        CGRect rect = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH / 3);
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _scrollView.imageURLStringsGroup = imagesURLStrings;
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
