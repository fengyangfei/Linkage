//
//  TRPopManager.m
//  YGTravel
//
//  Created by Mac mini on 16/2/1.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "TRPopManager.h"
#import "TRPopView.h"

@interface TRPopManager()
@property (nonatomic,strong) NSMutableArray *models;
@property (nonatomic,readonly) TRPopView *popView;
@end

@implementation TRPopManager
@synthesize popView = _popView;

+(TRPopManager *)shareInstance
{
    static TRPopManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TRPopManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.models = [NSMutableArray array];
    }
    return self;
}

-(void)show
{
    UIView *keyView = [UIApplication sharedApplication].keyWindow;
    [keyView addSubview:self.popView];
    [self.popView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyView);
    }];
}

-(void)hide
{
    if (_popView) {
        [self.models removeAllObjects];
        [self.popView removeFromSuperview];
        _popView = nil;
    }
}

-(void)addItemWithTitle:(NSString *)title andIcon:(UIImage *)icon handler:(FloatingButtonHandler)handler
{
    TRFloatingModel *model = [[TRFloatingModel alloc]init];
    model.title = title;
    model.icon = icon;
    model.handler = [handler copy];
    [self.models addObject:model];
}

#pragma mark - 各种属性
-(TRPopView *)popView
{
    if (!_popView) {
        _popView = [[TRPopView alloc]initWithItems:self.models];
    }
    return _popView;
}

@end
