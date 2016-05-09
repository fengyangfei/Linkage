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
#import "LinkUtil.h"

NSString *const DriverInfoDescriporType = @"DriverInfoRowType";
NSString *const DriverEditDescriporType = @"DriverEditRowType";

@interface DriverBaseCell()<UITextFieldDelegate>
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UITextField *textField;
@end

@implementation DriverBaseCell
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;
@synthesize textField = _textField;

-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
    [self.textField setEnabled:!self.rowDescriptor.disabled];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)update
{
    [super update];
    CargoToDriver *model = self.rowDescriptor.value;
    self.textLabel.attributedText = [model.driverName attributedStringWithTitle:@"司机："];
    self.detailLabel.attributedText = [model.driverLicense attributedStringWithTitle:@"牌号："];
    if (model.cargoNo && model.cargoNo.length > 0) {
        self.textField.text = model.cargoNo;
    }
}

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController<FormViewController> *)controller
{
    [self.textField becomeFirstResponder];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 80;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
    [self.formViewController endEditing:self.rowDescriptor];
    [self.formViewController textFieldDidEndEditing:textField];
}

#pragma mark - Helper
- (void)textFieldDidChange:(UITextField *)textField{
    CargoToDriver *model = self.rowDescriptor.value;
    if([self.textField.text length] > 0) {
        model.cargoNo = self.textField.text;
    } else {
        model.cargoNo = @"";
    }
}

#pragma mark - updateUI
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
        make.bottom.equalTo(self.contentView.bottom).offset(-6);
    }];
}

#pragma mark - 属性
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

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = @"请填入货柜号";
        _textField.delegate = self;
    }
    return _textField;
}
@end

@implementation DriverEditCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:DriverEditDescriporType];
}
@end

@implementation DriverInfoCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:DriverInfoDescriporType];
}
@end
