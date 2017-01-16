//
//  TagViewDataSource.m
//  Linkage
//
//  Created by lihaijian on 2017/1/15.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "TagViewDataSource.h"
#import "NSString+Hint.h"
#import "VCPageUtil.h"
#import "VCPageModel.h"
#import "VCIndex.h"
#import "VcodeUtil.h"
#import <QuartzCore/QuartzCore.h>
#define TagCellID @"TagCellID"
@interface TagViewDataSource()

@end

@implementation TagViewDataSource

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
    //NSString *imageIndex = [NSString stringWithFormat:@"%ld",(long) (index % 3 + 1)];
    NSString *imageIndex = [VcodeUtil tagBackgroudImage:index];
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
    if (page.name && page.name.length > 1) {
        firstLetterLabel.text = [[page.name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    }
    [firstLetterLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.centerX);
        make.centerY.equalTo(imageView.centerY);
    }];
    //url连接
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:titleLabel];
    titleLabel.text = page.name?:@"";
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
    if ([self.delegate respondsToSelector:@selector(VCTagView:didTapOnPage:)]) {
        [self.delegate VCTagView:gridView didTapOnPage:[self.pages objectAtIndex:position]];
    }
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    //gridView.editing = NO;
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(VCTagView:processDeleteActionForItemAtIndex:)]) {
        [self.delegate VCTagView:gridView processDeleteActionForItemAtIndex:index];
    }
}

- (void)GMGridView:(GMGridView *)gridView changedEdit:(BOOL)edit
{
    if ([self.delegate respondsToSelector:@selector(VCTagView:changedEdit:)]) {
        [self.delegate VCTagView:gridView changedEdit:edit];
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
        if ([self.delegate respondsToSelector:@selector(VCTagViewRefresh:)]) {
            [self.delegate VCTagViewRefresh:gridView];
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

@end
