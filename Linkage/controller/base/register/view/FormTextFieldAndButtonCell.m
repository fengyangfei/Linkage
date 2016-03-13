//
//  FormTextFieldAndButtonCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/13.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FormTextFieldAndButtonCell.h"
NSString *const XLFormRowDescriptorTypeTextAndButton = @"textAndButton";

@implementation FormTextFieldAndButtonCell
@synthesize button = _button;

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
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)configureLayout
{
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(11);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-11);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(80);
    }];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.right);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.right.equalTo(self.button.left);
    }];
}

-(void)configureConstraints
{
    if (self.dynamicCustomConstraints){
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
    NSDictionary * views = @{@"label": self.textLabel, @"textField": self.textField, @"button": self.button};
    self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textField]-[button(==80)]-|" options:0 metrics:nil views:views]];
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[label]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[textField]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[button]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    
    [self.contentView addConstraints:self.dynamicCustomConstraints];
}

-(void)updateConstraints
{
    [self configureConstraints];
    [super updateConstraints];
}

-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"测试" forState:UIControlStateNormal];
        [_button setBackgroundColor:[UIColor redColor]];
    }
    return _button;
}

@end
