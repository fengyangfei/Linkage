//
//  TRPopView.m
//  YGTravel
//
//  Created by Mac mini on 16/2/1.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "TRPopView.h"
#import "TRFloatingModel.h"
#import "TRPopButton.h"
#import <pop/POP.h>
#import <BlocksKit/BlocksKit+UIKit.h>

#define kTRPopUpMenuItemSize 50
#define kTRPopUpMenuItemPadding 15

#define kTRPopButtonViewRight 20
#define kTRPopButtonViewBottom 60
@interface TRPopView()
@property (nonatomic, assign) BOOL isMenuPresented;
@property (nonatomic, readonly) TRPopButton *buttonView;
@property (nonatomic, readonly) NSMutableArray *iconViews;
@property (nonatomic, readonly) NSArray *models;
@end

@implementation TRPopView
@synthesize isMenuPresented= _isMenuPresented;
@synthesize buttonView = _buttonView;
@synthesize iconViews = _iconViews;
@synthesize models = _models;

- (instancetype)initWithItems:(NSArray *)array
{
    self = [super init];
    if (self) {
        _isMenuPresented = NO;
        _models = [NSArray arrayWithArray:array];
        
        //UI
        self.backgroundColor = [UIColor clearColor];
        [self addButtonView];
        [self addIconViews];
        [self addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)addButtonView
{
    [self addSubview:self.buttonView];
    [self.buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-kTRPopButtonViewBottom);
        make.right.equalTo(self.right).offset(-kTRPopButtonViewRight);
        make.width.equalTo(kTRPopUpMenuItemSize);
        make.height.equalTo(kTRPopUpMenuItemSize);
    }];
}

-(void)addIconViews
{
    WeakSelf
    if (!_iconViews) {
        _iconViews = [[NSMutableArray alloc]init];
        UIView *preView = self.buttonView;
        for (TRFloatingModel *model in _models) {
            TRPopItemView *iconView = [[TRPopItemView alloc] initWithTitle:model.title andImage:model.icon];
            [iconView bk_addEventHandler:^(id sender) {
                [weakSelf controlPressed];
                model.handler();
            } forControlEvents:UIControlEventTouchUpInside];
            [_iconViews addObject:iconView];
            [self addSubview:iconView];
            
            CGSize size = [model.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            [iconView makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(preView.top).offset(-kTRPopUpMenuItemPadding);
                make.left.equalTo(self.right);
                make.height.equalTo(kTRPopUpMenuItemSize);
                make.width.equalTo(kTRPopUpMenuItemSize + size.width + 8);
            }];
            preView = iconView;
        }
    }
}

- (void)presentMenu
{
    _isMenuPresented = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    //动画
    POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.toValue = @(M_PI_4 * 3);
    [self.buttonView.layer pop_addAnimation:rotation forKey:@"rotation1"];
    
    POPBasicAnimation *color = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    color.toValue = [UIColor lightGrayColor];
    [self.buttonView.circleLayer pop_addAnimation:color forKey:@"color1"];
    
    int iconNumber = 0;
    for (UIView *icon in _iconViews) {
        POPBasicAnimation *push = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        push.beginTime = CACurrentMediaTime() + iconNumber * 0.1;
        push.duration = 0.2;
        push.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(self.bounds) - icon.bounds.size.width / 2 - kTRPopButtonViewRight, 0)];
        [icon.layer pop_addAnimation:push forKey:@"push1"];
        iconNumber += 1;
    }
}

- (void)dismissMenu
{
    _isMenuPresented = NO;
    self.backgroundColor = [UIColor clearColor];

    //动画
    POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.toValue = @(-M_PI_4 * 2);
    [self.buttonView.layer pop_addAnimation:rotation forKey:@"rotation2"];
    
    POPBasicAnimation *color = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
    color.toValue = UIColorFromRGB(0x007AFF);
    [self.buttonView.circleLayer pop_addAnimation:color forKey:@"color2"];
    
    int iconNumber = 0;
    for (UIView *icon in _iconViews) {
        POPBasicAnimation *push = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        push.beginTime = CACurrentMediaTime() + iconNumber * 0.1;
        push.duration = 0.2;
        push.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(self.bounds) + icon.bounds.size.width / 2, 0)];
        [icon.layer pop_addAnimation:push forKey:@"push2"];
        iconNumber += 1;
    }
}

-(void)controlPressed
{
    if(_isMenuPresented){
        [self dismissMenu];
    }else{
        [self presentMenu];
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(_isMenuPresented){
        return YES;
    }else{
        if(CGRectContainsPoint(self.buttonView.frame, point) == true){
            return YES;
        }
        return NO;
    }
}

#pragma mark － 属性
-(TRPopButton *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[TRPopButton alloc] init];
        [_buttonView addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonView;
}

@end


@interface TRPopItemView()
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *iconImageView;
@end

@implementation TRPopItemView
@synthesize titleLabel = _titleLabel;
@synthesize iconImageView = _iconImageView;

- (instancetype)initWithTitle:(NSString *)title andImageName:(NSString *)imageName
{
    return [self initWithTitle:title andImage:[UIImage imageNamed:imageName]];
}

- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.titleLabel.text = title;
        self.iconImageView.image = image;
        [self addSubview:self.iconImageView];
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right);
            make.centerY.equalTo(self.centerY);
            make.width.equalTo(kTRPopUpMenuItemSize);
            make.height.equalTo(kTRPopUpMenuItemSize);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.iconImageView.left).offset(-8);
            make.centerY.equalTo(self.centerY);
        }];
    }
    return self;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _titleLabel.layer.cornerRadius = 3;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.shadowOffset = CGSizeMake(1, 1);
        _iconImageView.layer.shadowRadius = 2;
        _iconImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _iconImageView.layer.shadowOpacity = 0.4;
    }
    return _iconImageView;
}

@end
