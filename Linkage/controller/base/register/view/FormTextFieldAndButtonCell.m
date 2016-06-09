//
//  FormTextFieldAndButtonCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/13.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FormTextFieldAndButtonCell.h"
#import <BlocksKit/BlocksKit+UIKit.h>
NSString *const XLFormRowDescriptorTypeTextAndButton = @"textAndButton";

@interface XLFormTextFieldCell(TextFiledAndButton)
-(void)customUpdateConstraints;
@end

@implementation XLFormTextFieldCell(TextFiledAndButton)
-(void)customUpdateConstraints
{
    [super updateConstraints];
}
@end

@implementation FormTextFieldAndButtonCell
@synthesize button = _button;
@synthesize textField = _textField;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:XLFormRowDescriptorTypeTextAndButton];
}

-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.button];
}

-(void)configureConstraints
{
    if (self.dynamicCustomConstraints){
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }else{
        self.dynamicCustomConstraints = [NSMutableArray array];
    }
    NSDictionary * views = @{@"label": self.textLabel, @"textField": self.textField, @"button": self.button};
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[label]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[textField]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[button]-7-|" options:0 metrics:nil views:views]];
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label(>=50)]-[textField]-[button(==120)]-11-|" options:0 metrics:nil views:views]];
    
    [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:self.textField
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:0.3
                                                                           constant:0.0]];
    
    [self.contentView addConstraints:self.dynamicCustomConstraints];
}

-(void)updateConstraints
{
    [self configureConstraints];
    [super customUpdateConstraints];
}


-(UIButton *)button
{
    WeakSelf
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        NSString *title = [NSString stringWithFormat:@"获取验证码"];
        [_button setTitle:title forState:UIControlStateNormal];
        [_button setBackgroundImage:CodeButtonImage forState:UIControlStateNormal];
        [_button bk_addEventHandler:^(id sender) {
            if (weakSelf.rowDescriptor.action.formBlock) {
                weakSelf.rowDescriptor.action.formBlock(weakSelf.rowDescriptor);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(UILabel *)textLabel
{
    UILabel *label = [super textLabel];
    label.textColor = IndexTitleFontColor;
    return label;
}

-(UITextField *)textField
{
    UITextField *textField = [super textField];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = IndexTitleFontColor;
    return textField;
}

@end
