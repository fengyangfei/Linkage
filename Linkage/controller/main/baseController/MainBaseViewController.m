//
//  MainBaseViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MainBaseViewController.h"
#import "SDCycleScrollView.h"
#import "LoginUser.h"

@interface XLFormViewController(MainBase)
-(void)superViewDidLoad;
@end

@implementation XLFormViewController(MainBase)
-(void)superViewDidLoad
{
    [super viewDidLoad];
}
@end

@interface MainBaseViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, readonly) UIView *topView;
@property (nonatomic, readonly) UIView *centerView;

@end

@implementation MainBaseViewController

@synthesize topView = _topView;
@synthesize centerView = _centerView;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super superViewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
    [self.view addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(150);
    }];
    
    [self.view addSubview:self.centerView];
    [self.centerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [self.centerView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.centerView);
    }];
    
    self.form.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - property
-(UIView *)topView
{
    if (!_topView) {
        _topView = ({
            //文字
            NSMutableArray *titleNames = [NSMutableArray array];
            //图片
            NSMutableArray *imagesURLStrings = [NSMutableArray array];
            [[LoginUser shareInstance].advertes enumerateObjectsUsingBlock:^(Advert *advert, NSUInteger idx, BOOL * stop) {
                [titleNames addObject: advert.title];
                [imagesURLStrings addObject:advert.icon];
            }];
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            cycleScrollView.titlesGroup = [titleNames copy];
            cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
            cycleScrollView.delegate = self;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView.imageURLStringsGroup = [imagesURLStrings copy];
            });
            cycleScrollView;
        });
    }
    return _topView;
}

-(UIView *)centerView
{
    if (!_centerView) {
        _centerView = [UIView new];
    }
    return _centerView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    Advert *advert = [[LoginUser shareInstance].advertes objectAtIndex:index];
    if (advert && advert.link) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:advert.link]];
    }
}

@end
