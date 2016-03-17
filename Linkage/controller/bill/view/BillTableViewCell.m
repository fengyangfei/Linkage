//
//  BillTableViewCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/15.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillTableViewCell.h"

@implementation BillTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self.contentView addSubview:self.billNumLable];
    [self.billNumLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.centerY);
    }];
    
    [self.contentView addSubview:self.timeLable];
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-8);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.centerY);
    }];
    
    [self.contentView addSubview:self.detailLable];
    [self.detailLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.top.equalTo(self.contentView.centerY);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.contentView addSubview:self.ratingLable];
    [self.ratingLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-8);
        make.top.equalTo(self.contentView.centerY);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

-(UILabel *)billNumLable
{
    if (!_billNumLable) {
        _billNumLable = [UILabel new];
    }
    return _billNumLable;
}

-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:12];
    }
    return _timeLable;
}

-(UILabel *)detailLable
{
    if (!_detailLable) {
        _detailLable = [UILabel new];
        _detailLable.font = [UIFont systemFontOfSize:10];
    }
    return _detailLable;
}

-(UILabel *)ratingLable
{
    if (!_ratingLable) {
        _ratingLable = [UILabel new];
        _ratingLable.font = [UIFont systemFontOfSize:10];
        _ratingLable.textColor = [UIColor grayColor];
    }
    return _ratingLable;
}

@end

@implementation CompanyTableViewCell

@end

@implementation SubCompanyTableViewCell

@end
