//
//  VCMenuPersonalCell.m
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCMenuPersonalCell.h"
NSString *const VCFormRowDescriptorTypePesonalHeader = @"vcMineHeaderRowCell";
@implementation VCMenuPersonalCell

+(void)load
{
    NSDictionary *dic = @{
                          VCFormRowDescriptorTypePesonalHeader:[self class]
                          };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:dic];
}

-(void)configure
{
    @weakify(self);
    [super configure];
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.left).offset(12);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(@(64));
        make.height.equalTo(@(64));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconView.right).offset(14);
        make.right.equalTo(self.contentView.right);
        make.centerY.equalTo(self.contentView.centerY);
    }];

}

-(void)update
{
    self.titleLabel.text = VCThemeString(@"completeInfoHint");
}

-(UILabel *)titleLabel
{
    UILabel *label = [super titleLabel];
    label.textColor = IndexTitleFontColor;
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

@end
