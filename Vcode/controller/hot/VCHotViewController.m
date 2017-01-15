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
#define kFixCategory @[@"首页", @"推荐", @"热门", @"本地"]
@interface VCHotViewController ()<ZJScrollPageViewDelegate,WYButtonChooseDelegate>
@property(readonly, nonatomic) ZJScrollPageView *scrollPageView;
@property(strong, nonatomic) ZJSegmentStyle *style;
@property(strong, nonatomic) NSMutableArray<NSString *> *titles;
@end

@implementation VCHotViewController
@synthesize scrollPageView = _scrollPageView;
@synthesize style = _style;

-(void)setupUI
{
    
    [super setupUI];
    [self setupTopScrollView];
    //顶部栏
    @weakify(self);
    [VCCategoryUtil syncCategory:^(NSArray *models) {
        @strongify(self);
        [self setupData];
    }];
    RACSignal *singal = [[NSNotificationCenter defaultCenter] rac_addObserverForName:VGMViewEditNotificationKey object:nil];
    [singal subscribeNext:^(NSNotification *note) {
        @strongify(self);
        self.style.scrollContentView = ![note.object boolValue];
    }];
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
        self.titles = nil;
        [self.titles addObjectsFromArray:titles];
        [self.scrollPageView reloadWithNewTitles:self.titles];
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
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [addBtn addTarget:self action:@selector(editCategory:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}

#pragma mark - WYButtonChooseDelegate 更新分类列表
- (void)categoryStatusUpdate{
    [self setupData];
}

#pragma mark - ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if (index == 0) {
            childVc = [[VCHomeViewController alloc]init];
        }else if (index == 1){
            childVc = [[VCHotChildViewController alloc] initWithRankType:RankTypeRecommend];
        }else if (index == 2){
            childVc = [[VCHotChildViewController alloc] initWithRankType:RankTypeHot];
        }else if (index == 3){
            childVc = [[VCHotChildViewController alloc] initWithRankType:RankTypeLocal];
        }else{
            childVc = [[VCHotChildViewController alloc] initWithRankType:RankTypeCategory];
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
    controller.topicDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(NSMutableArray<NSString *> *)titles
{
    if (!_titles) {
        _titles = [[NSMutableArray alloc] initWithArray:kFixCategory];
    }
    return _titles;
}

-(ZJScrollPageView *)scrollPageView
{
    if (!_scrollPageView) {
        // 设置附加按钮的背景图片
        _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:self.style titles:self.titles parentViewController:self delegate:self];
    }
    return _scrollPageView;
}

-(ZJSegmentStyle *)style
{
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
        _style.scaleTitle = YES;
        _style.showLine = NO;
        _style.gradualChangeTitleColor = YES;
        _style.contentViewBounces = NO;
        //是否可以滑动
        _style.scrollContentView = YES;
        _style.segmentContentInset = UIEdgeInsetsMake(0, 0, 0, 40);
    }
    return _style;
}
@end
