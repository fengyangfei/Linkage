//
//  CycleScrollCell.m
//  Linkage
//
//  Created by Mac mini on 16/7/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CycleScrollCell.h"
#import "LoginUser.h"
#import "SDCycleScrollView.h"

NSString *const CycleScrollDescriporRowType = @"CycleScrollRow";
@interface CycleScrollCell()<SDCycleScrollViewDelegate>
@property (nonatomic, readonly) SDCycleScrollView *scrollView;

@end

@implementation CycleScrollCell
@synthesize scrollView = _scrollView;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:CycleScrollDescriporRowType];
}

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

-(void)update
{
    [super update];
    NSArray *adverts = self.rowDescriptor.value;
    //文字
    NSMutableArray *titleNames = [NSMutableArray array];
    //图片
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    for (Advert *advert in adverts) {
        [titleNames addObject: advert.title];
        [imagesURLStrings addObject:advert.icon];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.titlesGroup = [titleNames copy];
        self.scrollView.imageURLStringsGroup = [imagesURLStrings copy];
    });
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return IPHONE_WIDTH * 3 / 5;
}

-(SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _scrollView.delegate = self;
    }
    return _scrollView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    NSArray *adverts = self.rowDescriptor.value;
    Advert *advert = [adverts objectAtIndex:index];
    if (advert && advert.link) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:advert.link]];
    }
}

@end
