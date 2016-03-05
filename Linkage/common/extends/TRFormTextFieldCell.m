//
//  TRFormTextFieldCell.m
//  YGTravel
//
//  Created by Mac mini on 16/1/4.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "TRFormTextFieldCell.h"

@implementation TRFormTextFieldCell

+(void)load
{
    NSDictionary *otherDic = @{XLFormRowDescriptorTypeText:[TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeName: [TRFormTextFieldCell class],
                               XLFormRowDescriptorTypePhone:[TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeURL:[TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeEmail: [TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeTwitter: [TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeAccount: [TRFormTextFieldCell class],
                               XLFormRowDescriptorTypePassword: [TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeNumber: [TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeInteger: [TRFormTextFieldCell class],
                               XLFormRowDescriptorTypeDecimal: [TRFormTextFieldCell class]
                               };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:otherDic];
}

-(UITextField *)textField
{
    UITextField *textField = [super textField];
    textField.textAlignment = NSTextAlignmentRight;
    return textField;
}

@end
