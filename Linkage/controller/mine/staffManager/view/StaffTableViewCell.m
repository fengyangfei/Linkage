//
//  StaffTableViewCell.m
//  Linkage
//
//  Created by Mac mini on 16/6/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "StaffTableViewCell.h"
#import "Staff.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const StaffDescriporRowType = @"staffDescriporRowType";

@implementation StaffTableViewCell
@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize detailLabel = _detailLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:StaffDescriporRowType];
}

-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
}

-(void)update
{
    [super update];
    Staff *model = self.rowDescriptor.value;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.staffIcon] placeholderImage:[UIImage imageNamed:@"user_header"]];
    self.titleLabel.text = model.userName;
    self.subTitleLabel.text = model.mobile;
    self.detailLabel.text = model.realname;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 64.0;
}

-(void)setupUI
{
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(12);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(12);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
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
        _titleLabel.textColor = IndexTitleFontColor;
        _titleLabel.font = IndexTitleFont;
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = IndexDetailFont;
        _subTitleLabel.textColor = IndexDetailFontColor;
    }
    return _subTitleLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = IndexDetailFont;
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = IndexDetailFontColor;
    }
    return _detailLabel;
}
@end
