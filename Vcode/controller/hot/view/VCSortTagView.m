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
#define SortTagCellID @"SortTagCellID"
@interface VCSortTagView()<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    NSInteger _lastDeleteItemIndexAsked;
}
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) GMGridView *gmGridView;
@property (nonatomic, strong) NSMutableArray *pages;

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)dataSetChange:(UISegmentedControl *)control;

@end

@implementation VCSortTagView
@synthesize titleView= _titleView;
@synthesize gmGridView = _gmGridView;
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
        self.pages = nil;
        [self.pages addObjectsFromArray:models];
        [self.gmGridView reloadData];
    }];
}

#pragma mark - helper
-(void)setupCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    VCPage *page =[self.pages objectAtIndex:indexPath.item];
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
    return [self.pages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SortTagCellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    return [self.pages count];
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
        cell.deleteButtonOffset = CGPointMake(14, -2);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    VCPage *page = (VCPage *)[self.pages objectAtIndex:index];
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
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    @weakify(self);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除标签？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        [VCPageUtil deleteFromDataBase:[self.pages objectAtIndex:index] completion:^{
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                
            }];
        }];
        [self.pages removeObjectAtIndex:index];
        [self.gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
    
}

- (void)GMGridView:(GMGridView *)gridView changedEdit:(BOOL)edit
{
}

//当前的viewController
-(UIViewController *)currentViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
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
    NSLog(@"moveItem -- %ld -- %ld", oldIndex, newIndex);
    @weakify(self);
    NSObject *object = [self.pages objectAtIndex:oldIndex];
    [self.pages removeObject:object];
    [self.pages insertObject:object atIndex:newIndex];
    [VCPageUtil truncateAll];
    for (int i = 0 ; i< self.pages.count; i++) {
        VCPage *page = [self.pages objectAtIndex:i];
        page.sortNumber = @(i);
        [VCPageUtil syncToDataBase:page completion:nil];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(VCSortTagViewRefresh:)]) {
            [self.delegate VCSortTagViewRefresh:self];
        }
    }];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    NSLog(@"change -- %ld -- %ld", index1, index2);
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
        _gmGridView.mainSuperView = self;
        _gmGridView.style = GMGridViewStylePush;
        _gmGridView.itemSpacing = 0;
        _gmGridView.centerGrid = NO;
        _gmGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //_gmGridView.centerGrid = YES;
        _gmGridView.backgroundColor = [UIColor whiteColor];
        _gmGridView.actionDelegate = self;
        _gmGridView.sortingDelegate = self;
        _gmGridView.transformDelegate = self;
        _gmGridView.dataSource = self;
    }
    return _gmGridView;
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
