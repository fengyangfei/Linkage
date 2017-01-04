//
//  VCRankViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCRankViewController.h"
#import "ZJScrollPageView.h"
#import "VCCategoryViewController.h"
#import "VCGlobalRankViewController.h"
#import "VCCountryViewController.h"

@interface VCRankViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@end

@implementation VCRankViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTopScrollView];
}

-(void)setupTopScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.scaleTitle = YES;
    style.gradualChangeTitleColor = YES;
    style.autoAdjustTitlesWidth = YES;
    //style.normalTitleColor = [UIColor lightGrayColor];
    //style.selectedTitleColor = [UIColor grayColor];
    self.titles = @[@"全球", @"分类", @"国家"];
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:scrollPageView];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if(index == 0){
            childVc = [[VCGlobalRankViewController alloc]init];
        }else if(index == 1){
            childVc = [[VCCategoryViewController alloc] init];
        }
        else if(index == 2){
            childVc = [[VCCountryViewController alloc] init];
        }
        childVc.title = self.titles[index];
    }
    return childVc;
}


@end
