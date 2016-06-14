//
//  NSString+Hint.m
//  Linkage
//
//  Created by Mac mini on 16/5/9.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "NSString+Hint.h"

@implementation NSString (Hint)

-(NSAttributedString *)attributedStringWithTitle:(NSString *)title
{
    return [self attributedStringWithTitle:title font:[UIFont systemFontOfSize:14]];
}

-(NSAttributedString *)attributedStringWithTitle:(NSString *)title font:(UIFont *)font
{
    return [self attributedStringWithTitle:title titleFont:font valueFont:font];
}

-(NSAttributedString *)attributedStringWithTitle:(NSString *)title titleFont:(UIFont *)titleFont valueFont:(UIFont *)valueFont
{
    NSMutableAttributedString *titleString = [[[NSAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:titleFont}] mutableCopy];
    NSAttributedString *valueString = [[NSAttributedString alloc]initWithString:self attributes:@{NSForegroundColorAttributeName:OrderTitleFontColor,NSFontAttributeName:valueFont}];
    [titleString appendAttributedString:valueString];
    return [titleString copy];
}

@end
