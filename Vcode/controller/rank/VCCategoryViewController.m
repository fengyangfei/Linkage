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
    self.categories = [VCCategoryUtil queryAllCategories];
    [self setupUI];
}

-(void)setupUI
{
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - helper


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VCCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCellID forIndexPath:indexPath];
    cell.category = [self.categories objectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - getter setter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        collectionView.pagingEnabled = YES;
        collectionView.scrollsToTop = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = YES;
        [collectionView registerClass:[VCCategoryCollectionViewCell class] forCellWithReuseIdentifier:CategoryCellID];
        collectionView.scrollEnabled = YES;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(IPHONE_WIDTH / 3, IPHONE_WIDTH / 3);
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewLayout = layout;
    }
    
    return _collectionViewLayout;
}


@end
