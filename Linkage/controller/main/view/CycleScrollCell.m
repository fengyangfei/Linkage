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
@property (nonatomic, readonly) UIView *scrollView;

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

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return IPHONE_WIDTH * 3 / 5;
}

-(UIView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({
            //文字
            NSMutableArray *titleNames = [NSMutableArray array];
            //图片
            NSMutableArray *imagesURLStrings = [NSMutableArray array];
            [[LoginUser shareInstance].advertes enumerateObjectsUsingBlock:^(Advert *advert, NSUInteger idx, BOOL * stop) {
                [titleNames addObject: advert.title];
                [imagesURLStrings addObject:advert.icon];
            }];
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            cycleScrollView.titlesGroup = [titleNames copy];
            cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
            cycleScrollView.delegate = self;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView.imageURLStringsGroup = [imagesURLStrings copy];
            });
            cycleScrollView;
        });
    }
    return _scrollView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    Advert *advert = [[LoginUser shareInstance].advertes objectAtIndex:index];
    if (advert && advert.link) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:advert.link]];
    }
}

@end
