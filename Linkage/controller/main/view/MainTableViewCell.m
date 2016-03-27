//
//  MainTableViewCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/6.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MainTableViewCell.h"
#import "AXRatingView.h"

NSString *const CompanyDescriporType = @"CompanyRowType";

@implementation MainTableViewCell

-(void)configure
{
    [super configure];
    [self setupUI];
}

-(void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

@implementation CompanyTableCell
@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize ratingView = _ratingView;
@synthesize button = _button;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:CompanyDescriporType];
}

-(void)update
{
    [super update];
    self.iconView.image = [UIImage imageNamed:@"logo"];
    self.titleLabel.text = @"承运商";
    self.subTitleLabel.text  = @"已接123单";
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 80.0;
}

-(void)setupUI
{
    [super setupUI];
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(@(52));
        make.height.equalTo(@(52));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(5);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.iconView.top);
    }];
    
    [self.contentView addSubview:self.ratingView];
    [self.ratingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(5);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.iconView.bottom);
        make.height.equalTo(@30);
    }];
    
    [self.contentView addSubview:self.button];
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-8);
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(@44);
        make.width.equalTo(@80);
    }];
    
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.button.left).offset(-5);
        make.bottom.equalTo(self.button.bottom);
    }];
}

#pragma mark - 属性
-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
    }
    return _iconView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.textColor =[UIColor grayColor];
    }
    return _subTitleLabel;
}

-(UIView *)ratingView
{
    if (!_ratingView) {
        _ratingView = ({
            AXRatingView *axRatinView = [[AXRatingView alloc]initWithFrame:CGRectZero];
            [axRatinView setStepInterval:1.0];
            axRatinView.value = 4.0;
            axRatinView;
        });
    }
    return _ratingView;
}

-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"下单" forState:UIControlStateNormal];
        [_button setBackgroundColor:ButtonColor];
    }
    return _button;
}
@end
