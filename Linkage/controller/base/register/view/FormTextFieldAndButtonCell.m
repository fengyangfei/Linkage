//
//  FormTextFieldAndButtonCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/13.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FormTextFieldAndButtonCell.h"
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
@synthesize textLabel = _textLabel;
@synthesize textField = _textField;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[FormTextFieldAndButtonCell class] forKey:XLFormRowDescriptorTypeTextAndButton];
}

-(void)configure
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.button];
    [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
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
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button]-0-|" options:0 metrics:nil views:views]];
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label(>=50)]-[textField]-[button(==150)]-0-|" options:0 metrics:nil views:views]];
    
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
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        [_button setTitle:@"测试" forState:UIControlStateNormal];
        [_button setBackgroundColor:[UIColor grayColor]];
    }
    return _button;
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel autolayoutView];
        [_textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    }
    return _textLabel;
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField autolayoutView];
        _textField.textAlignment = NSTextAlignmentRight;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.backgroundColor = [UIColor yellowColor];
    }
    return _textField;
}

@end
