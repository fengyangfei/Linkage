//
//  HJFormCell.m
//  Linkage
//
//  Created by Mac mini on 16/6/8.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "HJFormCell.h"

@implementation TRFormTextFieldCell

+(void)load
{
    NSDictionary *otherDic = @{XLFormRowDescriptorTypeText:[self class],
                               XLFormRowDescriptorTypeName: [self class],
                               XLFormRowDescriptorTypePhone:[self class],
                               XLFormRowDescriptorTypeURL:[self class],
                               XLFormRowDescriptorTypeEmail: [self class],
                               XLFormRowDescriptorTypeTwitter: [self class],
                               XLFormRowDescriptorTypeAccount: [self class],
                               XLFormRowDescriptorTypePassword: [self class],
                               XLFormRowDescriptorTypeNumber: [self class],
                               XLFormRowDescriptorTypeInteger: [self class],
                               XLFormRowDescriptorTypeDecimal: [self class]
                               };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:otherDic];
}

-(UILabel *)textLabel
{
    UILabel *textLabel = [super textLabel];
    textLabel.textColor = IndexTitleFontColor;
    return textLabel;
}

-(UITextField *)textField
{
    UITextField *textField = [super textField];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = IndexTitleFontColor;
    return textField;
}

@end

@implementation HJFormDateCell

+(void)load
{
    NSDictionary *otherDic = @{
                               XLFormRowDescriptorTypeDate: [self class],
                               XLFormRowDescriptorTypeTime: [self class],
                               XLFormRowDescriptorTypeDateTime : [self class],
                               XLFormRowDescriptorTypeCountDownTimer : [self class],
                               XLFormRowDescriptorTypeDateInline: [self class],
                               XLFormRowDescriptorTypeTimeInline: [self class],
                               XLFormRowDescriptorTypeDateTimeInline: [self class],
                               XLFormRowDescriptorTypeCountDownTimerInline : [self class]
                               };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:otherDic];
}

-(UILabel *)textLabel
{
    UILabel *textLabel = [super textLabel];
    textLabel.textColor = IndexTitleFontColor;
    return textLabel;
}

@end

@implementation HJFormSwitchCell

+(void)load
{
    NSDictionary *otherDic = @{
                               XLFormRowDescriptorTypeBooleanSwitch: [self class]
                               };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:otherDic];
}

-(UILabel *)textLabel
{
    UILabel *textLabel = [super textLabel];
    textLabel.textColor = IndexTitleFontColor;
    return textLabel;
}
@end


@implementation HJFormSelectorCell

+(void)load
{
    NSDictionary *otherDic = @{
                               XLFormRowDescriptorTypeSelectorPush: [self class],
                               XLFormRowDescriptorTypeSelectorPopover: [self class],
                               XLFormRowDescriptorTypeSelectorActionSheet: [self class],
                               XLFormRowDescriptorTypeSelectorAlertView: [self class],
                               XLFormRowDescriptorTypeSelectorPickerView: [self class],
                               XLFormRowDescriptorTypeMultipleSelector: [self class],
                               XLFormRowDescriptorTypeMultipleSelectorPopover: [self class],
                               XLFormRowDescriptorTypeInfo: [self class]
                               };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:otherDic];
}

-(UILabel *)textLabel
{
    UILabel *textLabel = [super textLabel];
    textLabel.textColor = IndexTitleFontColor;
    return textLabel;
}

-(UILabel *)detailTextLabel
{
    UILabel *detailTextLabel = [super detailTextLabel];
    detailTextLabel.textColor = IndexTitleFontColor;
    return detailTextLabel;
}

@end

@implementation HJFormTextViewCell

+(void)load
{
    NSDictionary *otherDic = @{
                               XLFormRowDescriptorTypeTextView: [self class],
                               };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:otherDic];
}

-(UILabel *)textLabel
{
    UILabel *textLabel = [super textLabel];
    textLabel.textColor = IndexTitleFontColor;
    return textLabel;
}

@end

@implementation HJFormButtonCell

+(void)load
{
    NSDictionary *otherDic = @{
                               XLFormRowDescriptorTypeButton: [self class]
                               };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:otherDic];
}

-(UILabel *)textLabel
{
    UILabel *textLabel = [super textLabel];
    textLabel.textColor = IndexTitleFontColor;
    return textLabel;
}

-(UILabel *)detailTextLabel
{
    UILabel *detailTextLabel = [super detailTextLabel];
    detailTextLabel.textColor = IndexTitleFontColor;
    return detailTextLabel;
}

@end


