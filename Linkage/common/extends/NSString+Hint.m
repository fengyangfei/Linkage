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
    NSMutableAttributedString *titleString = [[[NSAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}] mutableCopy];
    NSAttributedString *valueString = [[NSAttributedString alloc]initWithString:self attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [titleString appendAttributedString:valueString];
    return [titleString copy];
}

@end
