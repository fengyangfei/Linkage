//
//  XLFormValidator+Regex.m
//  Linkage
//
//  Created by Mac mini on 16/6/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "XLFormValidator+Regex.h"

@implementation XLFormValidator (Regex)

+(XLFormValidator *)emailRegexValidator
{
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"邮箱格式不正确" regex:EmailRegex];
}

+(XLFormValidator *)phoneNumValidator
{
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"电话格式不正确" regex:PhoneNumRegex];
}

@end