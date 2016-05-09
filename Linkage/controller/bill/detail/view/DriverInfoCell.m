//
//  DriverInfoCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverInfoCell.h"
#import "CargoToDriver.h"
#import "NSString+Hint.h"

NSString *const DriverInfoDescriporType = @"DriverInfoRowType";
@interface DriverInfoCell()
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UITextField *textField;
@end

@implementation DriverInfoCell
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;
@synthesize textField = _textField;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:DriverInfoDescriporType];
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
    CargoToDriver *model = self.rowDescriptor.value;
    self.textLabel.attributedText = [model.driverName attributedStringWithTitle:@"司机"];
    self.detailLabel.attributedText = [model.driverLicense attributedStringWithTitle:@"牌号"];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 80;
}

#pragma mark - UI
-(void)setupUI
{
    [self.contentView addSubview:self.textLabel];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.contentView.top).offset(5);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.contentView addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.bottom.equalTo(self.contentView.bottom).offset(-5);
    }];
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:12];
    }
    return _textLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _detailLabel;
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.placeholder = @"货柜号";
    }
    return _textField;
}


@end
