//
//  VCHotViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCHotViewController.h"
#import "ZJScrollPageView.h"
#import "VCHotChildViewController.h"
#import "VCHomeViewController.h"
#import "VCCategoryUtil.h"
#import "VCSearchView.h"
#import "WYButtonChooseViewController.h"
#import "VCCategory.h"

#define kButtonW 40
@interface VCHotViewController ()<ZJScrollPageViewDelegate>
@property(readonly, nonatomic) ZJScrollPageView *scrollPageView;
@property(strong, nonatomic) NSArray<NSString *> *titles;
@end

@implementation VCHotViewController
@synthesize scrollPageView = _scrollPageView;

-(void)setupUI
{
    [super setupUI];
    //顶部栏
    @weakify(self);
    [VCCategoryUtil syncCategory:^(NSArray *models) {
        @strongify(self);
        [self setupTopScrollView];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupData];
}

-(void)setupData
{
    @weakify(self);
    [VCCategoryUtil getVisibleCategories:^(NSArray *models) {
        @strongify(self);
        NSMutableArray *titles = [[NSMutableArray alloc]init];
        for (VCCategory *model in models) {
            [titles addObject:model.title];
        }
        self.titles = titles;
        [self.scrollPageView reloadWithNewTitles:titles];
    }];
}

-(void)setupTopScrollView
{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollPageView];
    
    //右边的阴影
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_right_more"]];
    rightView.frame = CGRectMake(IPHONE_WIDTH - rightView.bounds.size.width - kButtonW, 0, rightView.frame.size.width, 44);
    [self.view addSubview:rightView];
    
    //加号按钮
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - kButtonW, 0, kButtonW, 44)];
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(editCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}


#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if (index == 0) {
            childVc = [[VCHomeViewController alloc]init];
        }else{
            childVc = [[VCHotChildViewController alloc] init];
            childVc.title = self.titles[index];
        }
    }
    return childVc;
}


-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

#pragma mark - 事件
-(void)editCategory:(id)sender
{
    WYButtonChooseViewController *controller = [[WYButtonChooseViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(ZJScrollPageView *)scrollPageView
{
    if (!_scrollPageView) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        style.scaleTitle = YES;
        style.showLine = NO;
        style.gradualChangeTitleColor = YES;
        // 设置附加按钮的背景图片
        _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    }
    return _scrollPageView;
}
@end
