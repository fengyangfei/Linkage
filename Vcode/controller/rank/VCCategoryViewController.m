//
//  VCCategoryViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCategoryViewController.h"
#import "VCCategoryUtil.h"
#import "VCCategoryCollectionViewCell.h"
#import "VCHotChildViewController.h"
#define CategoryCellID @"CategoryCellID"

@interface VCCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (strong,nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic,strong) NSArray *categories;
@end

@implementation VCCategoryViewController
@synthesize collectionView = _collectionView;
@synthesize collectionViewLayout = _collectionViewLayout;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    @weakify(self);
    [VCCategoryUtil queryAllCategories:^(NSArray *models) {
        @strongify(self);
        self.categories = models;
        [self.collectionView reloadData];
    }];
}

-(void)setupUI
{
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - helper
-(void)setupCell:(VCCategoryCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    VCCategory *category = [self.categories objectAtIndex:indexPath.item];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:category.title]];
    [cell.contentView addSubview:imageView];
    @weakify(cell);
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(cell);
        make.width.equalTo(60);
        make.height.equalTo(60);
        make.centerX.equalTo(cell.centerX);
        make.top.equalTo(cell.top);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = IndexTitleFontColor;
    [cell.contentView addSubview:titleLabel];
    titleLabel.text = category.title;
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.centerX);
        make.top.equalTo(imageView.bottom).offset(5);
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VCCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(VCCategoryCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setupCell:cell forItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VCCategory *category = [self.categories objectAtIndex:indexPath.item];
    VCHotChildViewController *controller = [[VCHotChildViewController alloc]initWithRankType:RankTypeCategory frame:CGRectZero];
    controller.title = category.title;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - getter setter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, IPHONE_WIDTH, self.view.bounds.size.height - 150) collectionViewLayout:self.collectionViewLayout];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        collectionView.scrollsToTop = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
//        collectionView.bounces = NO;
        [collectionView registerClass:[VCCategoryCollectionViewCell class] forCellWithReuseIdentifier:CategoryCellID];
        collectionView.scrollEnabled = YES;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(IPHONE_WIDTH / 3 - 10, IPHONE_WIDTH / 3 - 10);
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionViewLayout = layout;
    }
    
    return _collectionViewLayout;
}


@end
