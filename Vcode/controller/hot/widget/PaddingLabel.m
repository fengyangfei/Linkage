//
//  PaddingLabel.m
//  Linkage
//
//  Created by Mac mini on 2017/1/6.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

- (void)drawRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 12, 0, 12);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
