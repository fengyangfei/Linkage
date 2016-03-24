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

-(void)update
{
    [super update];
    Address *address = self.rowDescriptor.value;
    self.textLabel.text = address.phoneNum;
    self.detailLabel.text = address.address;
    Address *defalutAddress = [Address defaultAddress];
    if ([address.phoneNum isEqualToString:defalutAddress.phoneNum] && [address.address isEqualToString:defalutAddress.address]) {
        [self.defaultAddrButton setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 100;
}

#pragma mark - 更新UI
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
    
    //一条线
    UIView *lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        view;
    });
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.bottom);
        make.left.equalTo(self.contentView.left).offset(12);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(@1);
    }];
    
    //设置默认
    [self.contentView addSubview:self.defaultAddrButton];
    [self.defaultAddrButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom);
        make.left.equalTo(self.contentView.left).offset(12);
        make.right.equalTo(self.contentView.centerX);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom);
        make.left.equalTo(self.contentView.centerX);
        make.right.equalTo(self.contentView.right).offset(-12);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

-(void)defalutAction:(id)sender
{
    Address *address = [self.rowDescriptor.value copy];
    [address save];
    [self.formViewController performFormSelector:NSSelectorFromString(@"setupForm") withObject:nil];
}

-(void)deleteAction:(id)sender
{
    Address *address = self.rowDescriptor.value;
    [address remove];
    [self.formViewController performFormSelector:NSSelectorFromString(@"setupForm") withObject:nil];
}

#pragma mark - 属性
-(UIButton *)defaultAddrButton
{
    if (!_defaultAddrButton) {
        _defaultAddrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"默认地址" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        [_defaultAddrButton setAttributedTitle:title forState:UIControlStateNormal];
        [_defaultAddrButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_defaultAddrButton setImage:[UIImage imageNamed:@"round_icon"] forState:UIControlStateNormal];
        [_defaultAddrButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _defaultAddrButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_defaultAddrButton addTarget:self action:@selector(defalutAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _defaultAddrButton;
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"删除" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        [_deleteButton setAttributedTitle:title forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
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
        _detailLabel.textColor = [UIColor darkGrayColor];
        _detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

@end