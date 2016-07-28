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
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"手机格式不正确" regex:PhoneNumRegex];
}

+(XLFormValidator *)passswordValidator
{
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"密码长度不能少于6位" regex:UserNameRegex];
}

+(XLFormValidator *)httpUrlValidator
{
    return [XLFormRegexValidator formRegexValidatorWithMsg:@"网址格式为:www.XXXX.com" regex:HttpUrlRegex];
}


@end
