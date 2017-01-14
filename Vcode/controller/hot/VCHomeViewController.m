//
//  VCHomeViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCHomeViewController.h"
#import "SDCycleScrollView.h"
#import "VCHomeUtil.h"
#import "VCIndex.h"
#import "VCTagView.h"
#import "VCPageUtil.h"
#import "VCPageModel.h"
#import "UIViewController+WebBrowser.h"
#import "VCTagSortViewController.h"

@interface VCHomeViewController ()<SDCycleScrollViewDelegate,VCTagViewDelegate,VCTagSortViewControllerDelegate>
@property (nonatomic, readonly) SDCycleScrollView *scrollView;
@property (nonatomic, readonly) VCTagView *tagView;
@property (nonatomic, strong) VCIndex *homeIndex;
@end

@implementation VCHomeViewController
@synthesize scrollView = _scrollView;
@synthesize tagView = _tagView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}

-(void)setupUI
{
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.tagView];
}

-(void)setupData
{
    @weakify(self);
    [VCHomeUtil queryModelFromServer:^(VCIndex *model) {
        @strongify(self);
        self.homeIndex = model;
        
        //图片
        NSMutableArray *imagesURLStrings = [NSMutableArray array];
        for (VCAd *advert in model.ads) {
            [imagesURLStrings addObject:advert.thumb?:@""];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollView.imageURLStringsGroup = [imagesURLStrings copy];
        });
    }];
    
    [self.tagView reloadData];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPageUpdateNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tagView reloadData];
    }];
}

//保存Page标签对象到数据库
-(void)syncPagesToDataBase:(NSArray *)pages completion:(void(^)(void))completion
{
    [VCPageUtil queryModelsFromDataBase:^(NSArray *models) {
        if (models.count <= 0) {
            for (VCPage *page in pages) {
                [VCPageUtil syncToDataBase:page completion:^{
                }];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                completion();
            }];
        }else{
            completion();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter setter
-(SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        CGRect rect = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH * 0.6);
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(VCTagView *)tagView
{
    if(!_tagView){
        CGRect rect = CGRectMake(0, IPHONE_WIDTH * 0.6, IPHONE_WIDTH, self.view.bounds.size.height - IPHONE_WIDTH * 0.6 - 120);
        _tagView = [[VCTagView alloc]initWithFrame:rect];
        _tagView.delegate = self;
    }
    return _tagView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark - TagViewDelegate
- (NSArray *)tagViewDataSource
{
    return [self.homeIndex pages];
}

- (void)VCTagView:(VCTagView *)gridView didTapOnPage:(VCPage *)page
{
    if (page) {
        [self presentWebBrowser:page.url];
    }
}

- (void)VCTagView:(VCTagView *)gridView changedEdit:(BOOL)edit
{
    [[NSNotificationCenter defaultCenter]postNotificationName:VGMViewEditNotificationKey object:@(edit)];
}

- (void)VCTagView:(VCTagView *)gridView sortTagOnClick:(UIButton *)sender
{
    VCTagSortViewController *sortViewController = [[VCTagSortViewController alloc]init];
    sortViewController.delegate = self;
    [self.navigationController pushViewController:sortViewController animated:YES];
}

#pragma mark - SortTagViewDelegate
-(void)refreshTag
{
    [self.tagView reloadData];
}


@end
