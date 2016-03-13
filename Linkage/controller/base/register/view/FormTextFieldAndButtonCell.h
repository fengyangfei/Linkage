//
//  FormTextFieldAndButtonCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/13.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import <UIKit/UIKit.h>

extern NSString *const XLFormRowDescriptorTypeTextAndButton;

@interface FormTextFieldAndButtonCell : XLFormTextFieldCell
@property (nonatomic, strong) UIButton *button;

@end
