//
//  VCTagView.m
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCTagView.h"
#import "NSString+Hint.h"
#define TagCellID @"TagCellID"
@interface VCTagView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@end

@implementation VCTagView
@synthesize titleView= _titleView;
@synthesize collectionView = _collectionView;

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
    [self addSubview:self.collectionView];
}

#pragma mark - helper
-(void)setupCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    [cell.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60);
        make.height.equalTo(60);
        make.centerX.equalTo(cell.centerX);
        make.top.equalTo(cell.top);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    [cell.contentView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.centerX);
        make.top.equalTo(imageView.bottom).offset(5);
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
    //return [[self.delegate tagViewDataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setupCell:cell forItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ss");
}

#pragma mark - getter setter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, IPHONE_WIDTH, self.bounds.size.height - 30) collectionViewLayout:self.collectionViewLayout];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        collectionView.scrollsToTop = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:TagCellID];
        collectionView.scrollEnabled = YES;
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(IPHONE_WIDTH / 4 - 10, IPHONE_WIDTH / 4 - 10);
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 10.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewLayout = layout;
    }
    return _collectionViewLayout;
}

-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30)];
        UIImageView *tagImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mark1"]];
        tagImage.frame = CGRectMake(10, 5, 20, 20);
        [_titleView addSubview:tagImage];
        
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, IPHONE_WIDTH - 100, 30)];
        NSString *hintStr = @"自定义标签 长按可删除";
        tagLabel.attributedText = [hintStr attributedStringWithFont:[UIFont systemFontOfSize:12] color:[UIColor grayColor]];
        [_titleView addSubview:tagLabel];
        
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(IPHONE_WIDTH - 80, 0, 100, 30)];
        [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *editStr = @"编辑排序";
        [editButton setAttributedTitle:[editStr attributedStringWithFont:[UIFont systemFontOfSize:12] color:[UIColor greenColor]] forState:UIControlStateNormal];
        [_titleView addSubview:editButton];
    }
    return _titleView;
}

#pragma mark - 事件
-(void)editAction:(id)sender
{

}

@end
