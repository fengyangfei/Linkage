//
//  VCCategoryCollectionViewCell.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCategoryCollectionViewCell.h"
@interface VCCategoryCollectionViewCell()
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation VCCategoryCollectionViewCell
@synthesize titleLabel = _titleLabel;
-(void)prepareForReuse
{
    [super prepareForReuse];
    [self setupUI];
}

-(void)setupUI
{
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.category.title]];
    [self.contentView addSubview:self.titleLabel];
    @weakify(self)
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    self.titleLabel.text = self.category.title;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end
