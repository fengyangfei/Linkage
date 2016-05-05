//
//  CargoFormCell.m
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import "CargoFormCell.h"
#import "Cargo.h"
#import <BlocksKit/UIView+BlocksKit.h>

NSString * const kCargoRowDescriptroType = @"cargoRowType";
@interface CargoFormCell()<UITextFieldDelegate>

@end
@implementation CargoFormCell
@synthesize leftButton = _leftButton;
@synthesize rightTextField = _rightTextField;
@synthesize rowDescriptor = _rowDescriptor;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:kCargoRowDescriptroType];
}

-(void)configure
{
    [super configure];
    UIView * separatorView = [UIView autolayoutView];
    [separatorView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1.0]];
    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.rightTextField];
    [self.contentView addSubview:separatorView];
    
    NSDictionary *views = @{@"leftButton":self.leftButton, @"rightTextFileld":self.rightTextField, @"separatorView": separatorView};
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[leftButton(100)]-[separatorView(1)]-[rightTextFileld]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[rightTextFileld]-0-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView(20)]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:constraints];
    [self.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)update
{
    [super update];
    Cargo *model = self.rowDescriptor.value;
    [self.leftButton setTitle:[model displayText] forState:UIControlStateNormal];
    //self.rightTextField.text = [model.cargoCount stringValue];
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    [self gotoOptionsViewController];
}

-(void)gotoOptionsViewController
{
    Cargo *model = self.rowDescriptor.value;
    UIViewController<XLFormRowDescriptorViewController> *optionsViewController = [[self.rowDescriptor.action.viewControllerClass alloc]init];
    optionsViewController.title = [model formDisplayText];
    optionsViewController.rowDescriptor = self.rowDescriptor;
    [self.formViewController.navigationController pushViewController:optionsViewController animated:YES];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 45.0;
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    WeakSelf
    _rowDescriptor = rowDescriptor;
    _rowDescriptor.onChangeBlock = ^(id oldValue, id newValue, XLFormRowDescriptor *rowDescriptor){
        if ([oldValue isKindOfClass:[NSString class]] && [newValue isKindOfClass:[NSString class]]) {
            [weakSelf.leftButton setTitle:newValue forState:UIControlStateNormal];
        }
    };
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField{
    Cargo *cargoModel = (Cargo *)self.rowDescriptor.value;
    if([self.rightTextField.text length] > 0) {
        cargoModel.cargoCount = @([self.rightTextField.text integerValue]);
    } else {
        cargoModel.cargoCount = @(0);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
}

#pragma mark - 各种属性
-(UIButton *)leftButton
{
    WeakSelf
    if (_leftButton) return _leftButton;
    _leftButton = [[XLFormRightImageButton alloc] init];
    [_leftButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_leftButton bk_whenTapped:^{
        [weakSelf gotoOptionsViewController];
    }];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XLForm.bundle/forwardarrow.png"]];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_leftButton addSubview:imageView];
    [_leftButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(8)]|" options:0 metrics:0 views:@{@"image": imageView}]];
    
    UIView * separatorTop = [UIView autolayoutView];
    UIView * separatorBottom = [UIView autolayoutView];
    [_leftButton addSubview:separatorTop];
    [_leftButton addSubview:separatorBottom];
    [_leftButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separatorTop(separatorBottom)][image][separatorBottom]|" options:0 metrics:0 views:@{@"image": imageView, @"separatorTop": separatorTop, @"separatorBottom": separatorBottom}]];
    _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    
    [_leftButton setTitleColor:[UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_leftButton setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    
    return _leftButton;
}

-(UITextField *)rightTextField
{
    if (!_rightTextField) {
        _rightTextField = [[UITextField alloc]init];
        [_rightTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_rightTextField setTextColor:[UIColor grayColor]];
        [_rightTextField setTextAlignment:NSTextAlignmentRight];
        _rightTextField.delegate = self;
    }
    return _rightTextField;
}

@end
