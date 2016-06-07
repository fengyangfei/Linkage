//
//  MainTableViewCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/6.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MainTableViewCell.h"
#import "BillTypeViewController.h"
#import "Favorite.h"
#import "Company.h"

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
    Favorite *favorite = self.rowDescriptor.value;
    if (StringIsNotEmpty(favorite.logo)) {
        self.iconView.image = [UIImage imageNamed:favorite.logo];
    }else{
        self.iconView.image = [UIImage imageNamed:@"logo"];
    }
    self.titleLabel.text = favorite.companyName;
    self.subTitleLabel.text  = [NSString stringWithFormat:@"已接%d单", [favorite.orderNum intValue]];
    self.ratingView.value = MIN(MAX([favorite.score intValue], 0),5);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 85.0;
}

-(void)clickAction:(id)sender
{
    UIViewController *controller = [[BillTypeViewController alloc] initWithCompany:self.rowDescriptor.value];
    controller.hidesBottomBarWhenPushed = YES;
    [self.formViewController.navigationController pushViewController:controller animated:YES];
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
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [self.contentView addSubview:self.ratingView];
    [self.ratingView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(5);
        make.top.equalTo(self.titleLabel.bottom);
    }];
    
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(5);
        make.top.equalTo(self.ratingView.bottom);
    }];
    
    [self.contentView addSubview:self.button];
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-8);
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@60);
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
        _titleLabel.textColor = IndexFontColor;
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

-(AXRatingView *)ratingView
{
    if (!_ratingView) {
        _ratingView = [[AXRatingView alloc]initWithFrame:CGRectZero];
        _ratingView.enabled = NO;
        _ratingView.value = 0;
    }
    return _ratingView;
}

-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"下单" forState:UIControlStateNormal];
        [_button setTitleColor:HeaderColor forState:UIControlStateNormal];
        [_button setBackgroundImage:ButtonFrameImage forState:UIControlStateNormal];
        [_button setBackgroundImage:ButtonFrameImage forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
@end
