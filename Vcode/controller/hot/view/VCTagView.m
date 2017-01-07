//
//  VCTagView.m
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCTagView.h"
#import "VCIndex.h"
#import "NSString+Hint.h"
#import "GMGridView.h"
#import <QuartzCore/QuartzCore.h>
#define TagCellID @"TagCellID"
@interface VCTagView()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) GMGridView *gmGridView;

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)dataSetChange:(UISegmentedControl *)control;

@end

@implementation VCTagView
@synthesize titleView= _titleView;
@synthesize collectionView = _collectionView;
@synthesize gmGridView = _gmGridView;

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
    //[self addSubview:self.collectionView];
    [self addSubview:self.gmGridView];
}

#pragma mark - 对外发布方法
-(void)reloadData
{
    [self.gmGridView reloadData];
}

#pragma mark - helper
-(void)setupCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    VCPage *page =[[self.delegate tagViewDataSource] objectAtIndex:indexPath.item];
    //图片
    NSString *imageIndex = [NSString stringWithFormat:@"%ld",(long) (indexPath.item % 3 + 1)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageIndex]];
    [cell.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60);
        make.height.equalTo(60);
        make.centerX.equalTo(cell.centerX);
        make.top.equalTo(cell.top);
    }];
    //首字母
    UILabel *firstLetterLabel = [[UILabel alloc]init];
    [cell.contentView addSubview:firstLetterLabel];
    firstLetterLabel.text = [[page.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    [firstLetterLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.centerX);
        make.centerY.equalTo(imageView.centerY);
    }];
    //url连接
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:titleLabel];
    titleLabel.text = page.name;
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.centerX);
        make.width.equalTo(50);
        make.top.equalTo(imageView.bottom).offset(5);
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.delegate tagViewDataSource] count];
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

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [[self.delegate tagViewDataSource] count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(IPHONE_WIDTH / 4, IPHONE_WIDTH / 4);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    VCPage *page = (VCPage *)[[self.delegate tagViewDataSource] objectAtIndex:index];
    //图片
    NSString *imageIndex = [NSString stringWithFormat:@"%ld",(long) (index % 3 + 1)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageIndex]];
    [cell.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60);
        make.height.equalTo(60);
        make.centerX.equalTo(cell.centerX);
        make.top.equalTo(cell.top);
    }];
    //首字母
    UILabel *firstLetterLabel = [[UILabel alloc]init];
    [cell.contentView addSubview:firstLetterLabel];
    firstLetterLabel.text = [[page.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    [firstLetterLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.centerX);
        make.centerY.equalTo(imageView.centerY);
    }];
    //url连接
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:titleLabel];
    titleLabel.text = page.name;
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.centerX);
        make.width.equalTo(50);
        make.top.equalTo(imageView.bottom).offset(5);
    }];
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %ld", (long)position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    //_lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //[_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        //[_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    //NSObject *object = [[self.delegate tagViewDataSource] objectAtIndex:oldIndex];
    //[_currentData removeObject:object];
    //[_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    //[_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(IPHONE_WIDTH / 4, IPHONE_WIDTH / 4);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %ld", (long)index];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.font = [UIFont boldSystemFontOfSize:15];
    [fullView addSubview:label];
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}

//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////

- (void)addMoreItem
{
    // Example: adding object at the last position
//    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
//    
//    [_currentData addObject:newItem];
//    [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)removeItem
{
    // Example: removing last item
//    if ([_currentData count] > 0)
//    {
//        NSInteger index = [_currentData count] - 1;
//        
//        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
//        [_currentData removeObjectAtIndex:index];
//    }
}

- (void)refreshItem
{
    // Example: reloading last item
//    if ([_currentData count] > 0)
//    {
//        int index = [_currentData count] - 1;
//        
//        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];
//        
//        [_currentData replaceObjectAtIndex:index withObject:newMessage];
//        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
//    }
}

- (void)dataSetChange:(UISegmentedControl *)control
{
//    _currentData = ([control selectedSegmentIndex] == 0) ? _data : _data2;
//    [_gmGridView reloadData];
}

#pragma mark - getter setter
-(GMGridView *)gmGridView
{
    if (!_gmGridView) {
        _gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 30, IPHONE_WIDTH, self.bounds.size.height - 30)];
        _gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gmGridView.backgroundColor = [UIColor whiteColor];

        _gmGridView.style = GMGridViewStyleSwap;
        _gmGridView.itemSpacing = 0;
        _gmGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //_gmGridView.centerGrid = YES;
        _gmGridView.actionDelegate = self;
        _gmGridView.sortingDelegate = self;
        _gmGridView.transformDelegate = self;
        _gmGridView.dataSource = self;
    }
    return _gmGridView;
}

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
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
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
