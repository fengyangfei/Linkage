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
#import "VCPageUtil.h"
#import "VCPageModel.h"
#import <QuartzCore/QuartzCore.h>
#import "TagViewDataSource.h"
@interface VCTagView()<VCTagDataSourceDelegate>
{
    NSInteger _lastDeleteItemIndexAsked;
}
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) GMGridView *gmGridView;
@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, strong) TagViewDataSource *tagDataSource;

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)dataSetChange:(UISegmentedControl *)control;

@end

@implementation VCTagView
@synthesize titleView= _titleView;
@synthesize collectionView = _collectionView;
@synthesize gmGridView = _gmGridView;
@synthesize pages = _pages;
@synthesize tagDataSource = _tagDataSource;

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
    [self.delegate VCTagView:self didTapOnPage:page];
}

- (void)VCTagView:(GMGridView *)gridView changedEdit:(BOOL)edit
{
    [self.delegate VCTagView:self changedEdit:edit];
}

- (void)VCTagView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
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
        [gridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [[self currentViewController] presentViewController:alertController animated:YES completion:^{
        
    }];
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
        _gmGridView.enableEditOnLongPress = YES;
        _gmGridView.disableEditOnEmptySpaceTap = YES;
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
        NSString *hintStr = @"自定义标签 长按可删除";
        tagLabel.attributedText = [hintStr attributedStringWithFont:[UIFont systemFontOfSize:12] color:[UIColor grayColor]];
        [_titleView addSubview:tagLabel];
        
        UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(IPHONE_WIDTH - 80, 0, 100, 30)];
        [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *editStr = @"编辑排序";
        [editButton setAttributedTitle:[editStr attributedStringWithFont:[UIFont systemFontOfSize:12] color:VHeaderColor] forState:UIControlStateNormal];
        [_titleView addSubview:editButton];
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

#pragma mark - 事件
-(void)editAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(VCTagView:sortTagOnClick:)]) {
        [self.delegate VCTagView:self sortTagOnClick:sender];
    }
}

-(void)cancelEditing
{
    if (self.gmGridView.isEditing) {
        self.gmGridView.editing = NO;
    }
}

@end
