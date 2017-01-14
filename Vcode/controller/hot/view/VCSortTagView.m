//
//  VCSortTagView.m
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//
#import "VCSortTagView.h"
#import "VCIndex.h"
#import "NSString+Hint.h"
#import "GMGridView.h"
#import "VCPageUtil.h"
#import "VCPageModel.h"
#import <QuartzCore/QuartzCore.h>
#import "TagViewDataSource.h"
@interface VCSortTagView()<VCTagDataSourceDelegate>
{
    NSInteger _lastDeleteItemIndexAsked;
}
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) GMGridView *gmGridView;
@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, strong) TagViewDataSource *tagDataSource;

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)dataSetChange:(UISegmentedControl *)control;

@end

@implementation VCSortTagView
@synthesize titleView= _titleView;
@synthesize gmGridView = _gmGridView;
@synthesize tagDataSource = _tagDataSource;
@synthesize pages = _pages;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self addSubview:self.titleView];
    [self addSubview:self.gmGridView];
}

#pragma mark - 对外发布方法
-(void)reloadData
{
    @weakify(self);
    [VCPageUtil queryModelsFromDataBase:^(NSArray *models) {
        @strongify(self);
        [self.pages removeAllObjects];
        [self.pages addObjectsFromArray:models];
        [self.gmGridView reloadData];
    }];
}

#pragma mark - VCTagDataSourceDelegate
- (void)VCTagView:(GMGridView *)gridView didTapOnPage:(VCPage *)page
{
}

- (void)VCTagView:(GMGridView *)gridView changedEdit:(BOOL)edit
{
}

- (void)VCTagView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
}

- (void)VCTagViewRefresh:(GMGridView *)gridView
{
    [self.delegate VCSortTagViewRefresh:self];
}

//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////

- (void)addMoreItem
{
}

- (void)removeItem
{

}

- (void)refreshItem
{

}

- (void)dataSetChange:(UISegmentedControl *)control
{
}

#pragma mark - getter setter
-(GMGridView *)gmGridView
{
    if (!_gmGridView) {
        _gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 30, IPHONE_WIDTH, self.bounds.size.height - 30)];
        _gmGridView.mainSuperView = self;
        _gmGridView.style = GMGridViewStylePush;
        _gmGridView.itemSpacing = 0;
        _gmGridView.centerGrid = NO;
        _gmGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //_gmGridView.centerGrid = YES;
        _gmGridView.backgroundColor = [UIColor whiteColor];
        _gmGridView.actionDelegate = self.tagDataSource;
        _gmGridView.sortingDelegate = self.tagDataSource;
        _gmGridView.transformDelegate = self.tagDataSource;
        _gmGridView.dataSource = self.tagDataSource;
    }
    return _gmGridView;
}

-(TagViewDataSource *)tagDataSource
{
    if (!_tagDataSource) {
        _tagDataSource = [[TagViewDataSource alloc]init];
        _tagDataSource.pages = self.pages;
        _tagDataSource.delegate = self;
    }
    return _tagDataSource;
}


-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
        UIImageView *tagImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mark1"]];
        tagImage.frame = CGRectMake(10, 5, 20, 20);
        [_titleView addSubview:tagImage];
        
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, IPHONE_WIDTH - 100, 30)];
        NSString *hintStr = @"自定义标签 长按拖动排序";
        tagLabel.attributedText = [hintStr attributedStringWithFont:[UIFont systemFontOfSize:12] color:[UIColor grayColor]];
        [_titleView addSubview:tagLabel];
    }
    return _titleView;
}

-(NSMutableArray *)pages
{
    if (!_pages) {
        _pages = [[NSMutableArray alloc]init];
    }
    return _pages;
}

@end
