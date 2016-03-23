//
//  AddressCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressCell.h"
#import "Address.h"

NSString * const kAddressRowDescriptroType = @"addressRowType";;
@interface AddressCell()

@end

@implementation AddressCell
@synthesize defaultAddrButton = _defaultAddrButton;
@synthesize deleteButton = _deleteButton;
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:kAddressRowDescriptroType];
}

-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureUI];
}

-(void)configureUI
{
    [self.contentView addSubview:self.textLabel];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(5);
        make.left.equalTo(self.contentView.left).offset(12);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(@30);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.bottom);
        make.left.equalTo(self.contentView.left).offset(12);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(@30);
    }];
    
    [self.contentView addSubview:self.defaultAddrButton];
    [self.defaultAddrButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.bottom);
        make.left.equalTo(self.contentView.left).offset(12);
        make.right.equalTo(self.contentView.centerX);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.bottom);
        make.left.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-12);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

-(void)update
{
    [self update];
    Address *address = self.rowDescriptor.value;
    self.textLabel.text = address.target;
    self.detailLabel.text = address.specific;
}

#pragma mark - 属性
-(UIButton *)defaultAddrButton
{
    if (!_defaultAddrButton) {
        _defaultAddrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultAddrButton setTitle:@"默认地址" forState:UIControlStateNormal];
        [_defaultAddrButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_defaultAddrButton setImage:[UIImage imageNamed:@"round_icon"] forState:UIControlStateNormal];
        [_defaultAddrButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _defaultAddrButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _defaultAddrButton;
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _deleteButton;
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
    }
    return _textLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
    }
    return _detailLabel;
}

@end