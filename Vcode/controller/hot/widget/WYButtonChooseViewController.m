//
//  WYButtonChooseViewController.m
//  WYButtonChooseView
//
//  Created by dai.fengyi on 15/6/3.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "WYButtonChooseViewController.h"
#import "WYButtonChooseView.h"
#import "VCCategory.h"
#import "PaddingLabel.h"
#import "VCCategoryUtil.h"
#define kHeaderHeight       36
#define kDefaultY           20

//Dock
#define kDockHeight 49
//WYNewsVC
#define kTopicHeaderHeight      36
#define kTopicHeaderBgColor         [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1]

//WYButtonChooseView
#define kButtonChooseViewSelectedTopicMaxCount  24

@interface WYButtonChooseViewController () <LabelChooseDelegate>
@property (strong, nonatomic) WYButtonChooseView *topChooseView;
@property (strong, nonatomic) WYButtonChooseView *bottomChooseView;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIView *header;
@end

@implementation WYButtonChooseViewController
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.title = @"标签设置";
//        [self initSubviews];
//    }
//    return self;
//}

- (void)setSelectedArray:(NSMutableArray *)selectedArray
{
    _selectedArray = selectedArray;
//    if (_selectedArray != nil) {
//        for (VCCategory *category in _selectedArray) {
//            [_topChooseView addButtonWith:category.title position:CGPointZero];
//        }
//    }
//    [self refreshView];
}

- (void)setUnSelectedArray:(NSMutableArray *)unSelectedArray
{
    _unSelectedArray = unSelectedArray;
//    if (_unSelectedArray != nil) {
//        for (VCCategory *category in _unSelectedArray) {
//            [_bottomChooseView addButtonWith:category.title position:CGPointZero];
//        }
//    }
//    [self refreshView];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self.view];
    CGRect frame = view.bounds;
    frame.size.height = frame.size.height - kDockHeight;//调整dock高度
    frame.origin.y = -frame.size.height;
    self.view.frame = frame;
    [UIView animateWithDuration:kDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    //在加入到view中才知道view.frame,之前在refreshView中的self.view.frame是满屏尺寸
    [self refreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubviews];
    [self loadData];
}

-(void)dealloc
{
    NSLog(@"chooseViewController Dealloc");
}

- (void)loadData
{
    @weakify(self);
    [VCCategoryUtil queryModelsFromDataBase:^(NSArray *models) {
        @strongify(self);
        NSInteger count = models.count;
        for (int i  = 0; i < count; i++) {
            VCCategory *category = [models objectAtIndex:i];
            CGFloat buttonX = 0;
            CGFloat buttonY = 0;
            if (i == 0) {
                buttonX = kMarginW;
                buttonY = kMarginH;
            }else {
                buttonX = (kButtonW + kMarginW) * (i % 4) + kMarginW;
                buttonY = (kButtonH + kMarginH) * (i / 4) + kMarginH;
            }
            [self.topChooseView addButtonWith:category.title position:CGPointMake(buttonX, buttonY) needRefresh:NO];
        }
        self.topChooseView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, (kButtonH + kMarginH) * ceil(count / 4.0) + kMarginH);
        [self refreshViewNotAnimation];
    }];
}

- (void)initSubviews
{
//    self.view.clipsToBounds = YES;
    [self prefersStatusBarHidden];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeaderHeight)];
    _header.backgroundColor = kTopicHeaderBgColor;
    [self.view addSubview:_header];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 80, kHeaderHeight)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"切换栏目";
    [_header addSubview:label];
    
    /*
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - kMarginW - kHeaderHeight, 0, 30, kHeaderHeight)];
    [button1 setImage:[UIImage imageNamed:@"channel_nav_arrow"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(spreadAction:) forControlEvents:UIControlEventTouchUpInside];
    [_header addSubview:button1];
     */
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - kMarginW - 65, 0, 60, kHeaderHeight)];
    [button2 setTitle:@"排序" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:12];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button2 setBackgroundImage:[UIImage imageNamed:@"channel_edit_button_bg"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"channel_edit_button_selected_bg"] forState:UIControlStateHighlighted];
    [button2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_header addSubview:button2];
    
    _topChooseView = [[WYButtonChooseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_header.frame), [UIScreen mainScreen].bounds.size.width, 150)];
    _topChooseView.chooseDelegate = self;
    _topChooseView.dragable = YES;
    [self.view addSubview:_topChooseView];
    
    
    _label = [[PaddingLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topChooseView.frame), [UIScreen mainScreen].bounds.size.width, 30)];
    _label.font = [UIFont systemFontOfSize:14];
    _label.backgroundColor = kTopicHeaderBgColor;
    _label.text = @"点击添加更多类型导航";
    [self.view addSubview:_label];

    _bottomChooseView = [[WYButtonChooseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_label.frame), [UIScreen mainScreen].bounds.size.width, 200)];
    _bottomChooseView.chooseDelegate = self;
    _bottomChooseView.dragable = NO;
    [self.view addSubview:_bottomChooseView];
    
//    _topChooseView.clipsToBounds = NO;
//    _bottomChooseView.clipsToBounds = NO;
}

- (void)refreshData
{
    NSMutableArray *mutArray = [NSMutableArray array];
    for (UIButton *button in _topChooseView.buttonArray) {
        [_selectedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            VCCategory *category = obj;
            if ([category.title isEqualToString:button.titleLabel.text]) {
                [mutArray addObject:category];
                *stop = YES;
            }
        }];
        [_unSelectedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            VCCategory *category = obj;
            if ([category.title isEqualToString:button.titleLabel.text]) {
                [mutArray addObject:category];
                *stop = YES;
            }
        }];
    }
    _selectedArray = mutArray;
}

- (void)synToDataBase
{
    NSMutableArray *mutArray = [NSMutableArray array];
    for (UIButton *button in _topChooseView.buttonArray) {
        [mutArray addObject:button.titleLabel.text];
    }
}

//在这里调整各个子view的尺寸，buttonChooseView的尺寸有其contentsize传出
- (void)refreshView
{
    [UIView animateWithDuration:kDuration animations:^{
        _topChooseView.frame = CGRectMake(0, CGRectGetMaxY(_header.frame), _topChooseView.contentSize.width, _topChooseView.contentSize.height);
        _label.frame = CGRectMake(0, CGRectGetMaxY(_topChooseView.frame), self.view.frame.size.width, 30);
        _bottomChooseView.frame = CGRectMake(0, CGRectGetMaxY(_label.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_label.frame));
    }];
}

- (void)refreshViewNotAnimation
{
    _topChooseView.frame = CGRectMake(0, CGRectGetMaxY(_header.frame), _topChooseView.contentSize.width, _topChooseView.contentSize.height);
    _label.frame = CGRectMake(0, CGRectGetMaxY(_topChooseView.frame), self.view.frame.size.width, 30);
    _bottomChooseView.frame = CGRectMake(0, CGRectGetMaxY(_label.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_label.frame));
}
#pragma mark - button Action
- (void)switchAction:(UIButton *)sender
{
    UILabel *label = _header.subviews[0];
    UIButton *button2 = _header.subviews[1];
    if ([button2.titleLabel.text isEqualToString:@"排序"]) {
        label.text = @"拖动排序";
        [button2 setTitle:@"完成" forState:UIControlStateNormal];
        _topChooseView.edit = YES;
        _label.hidden = YES;
        _bottomChooseView.hidden = YES;
    }else {
        if (sender == nil) {
            return;
        }
        label.text = @"切换栏目";
        [button2 setTitle:@"排序" forState:UIControlStateNormal];
        _topChooseView.edit = NO;
        _label.hidden = NO;
        _bottomChooseView.hidden = NO;
        
        //点击完成时把类型返回
        if (self.topicDelegate && [self.topicDelegate respondsToSelector:@selector(buttonChooseViewTopicArrayDidChange:)]) {
            [self.topicDelegate buttonChooseViewTopicArrayDidChange:_selectedArray];
        }
    }
}



- (void)spreadAction:(UIButton *)sender
{
    //1. 更新UI上作所改动至数组
    [self refreshData];
    [UIView animateWithDuration:kDuration animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -frame.size.height;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    //2. 通知topicDelegate数据改动
    [self.topicDelegate buttonChooseViewTopicArrayDidChange:_selectedArray];
}


#pragma mark - ChooseButtonView delegate
- (void)didSelectedButton:(WYLabelButton *)button
{
    if (button.superview == _topChooseView) {
        //收起并跳转到该栏目新闻
        if (button.isEdit) {//编辑状态
            [_bottomChooseView addButtonWith:button.titleLabel.text position:[_bottomChooseView convertPoint:button.frame.origin fromView:_topChooseView]];
            [_topChooseView removeButton:button];
        } else {//非编辑状态
            //1. 收view
            //lihaijian修改，点击按钮时不收回
            //[self spreadAction:nil];
            //2. 通知topicDelegate所选
            if (self.topicDelegate && [self.topicDelegate respondsToSelector:@selector(buttonChooseViewDidSelected:)]) {
                [self.topicDelegate buttonChooseViewDidSelected:button.titleLabel.text];
            }
        }
    }else {
        if (_topChooseView.buttonArray.count < kButtonChooseViewSelectedTopicMaxCount) {
            [_topChooseView addButtonWith:button.titleLabel.text position:[_topChooseView convertPoint:button.frame.origin fromView:_bottomChooseView]];
            [_bottomChooseView removeButton:button];
        }else {
            return;
        }
    }
    [self refreshView];
}

- (void)didSetEditable:(id)chooseView
{
    [self switchAction:nil];
}
@end
