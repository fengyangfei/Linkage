//
//  DriverInfoCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "TaskCell.h"
#import "Task.h"
#import "NSString+Hint.h"
#import "LinkUtil.h"

NSString *const TaskInfoDescriporType = @"TaskInfoRowType";
NSString *const TaskEditDescriporType = @"TaskEditRowType";

@interface TaskCell()<UITextFieldDelegate>
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UITextField *textField;
@end

@implementation TaskCell
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
    Task *model = self.rowDescriptor.value;
    if (model) {
        if(model.driverName){
            self.textLabel.attributedText = [model.driverName attributedStringWithTitle:@"司机："];
        }
        if (model.driverLicense) {
            self.detailLabel.attributedText = [model.driverLicense attributedStringWithTitle:@"牌号："];
        }
        if (model.cargoNo && model.cargoNo.length > 0) {
            self.textField.text = model.cargoNo;
        }
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
    Task *model = self.rowDescriptor.value;
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

//编辑Cell
@implementation TaskEditCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TaskEditDescriporType];
}
@end

//查看cell
@interface TaskInfoCell()
@property (nonatomic, readonly) UILabel *statusLabel;
@end

@implementation TaskInfoCell
@synthesize statusLabel = _statusLabel;
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TaskInfoDescriporType];
}

-(void)configure
{
    [super configure];
    [self.textField setEnabled:NO];
}

-(void)setupUI
{
    [super setupUI];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.right.equalTo(self.contentView.right);
        make.width.equalTo(80);
    }];
}

-(void)update
{
    Task *model = self.rowDescriptor.value;
    if (model) {
        self.textLabel.attributedText = [model.driverName ?:@"" attributedStringWithTitle:@"司机："];
        self.detailLabel.attributedText = [model.driverLicense ?:@"" attributedStringWithTitle:@"车牌号："];
        self.textField.attributedText = [model.cargoNo ?:@"" attributedStringWithTitle:@"货柜号："];
        self.statusLabel.text = [[LinkUtil taskStatus] objectForKey:@([model.status intValue])];
    }
}

-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.backgroundColor = ButtonColor;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:14];
    }
    return _statusLabel;
}
@end