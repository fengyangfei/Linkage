//
//  NSString+Hint.h
//  Linkage
//
//  Created by Mac mini on 16/5/9.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hint)
-(NSAttributedString *)attributedStringWithTitle:(NSString *)title;
-(NSAttributedString *)attributedStringWithTitle:(NSString *)title font:(UIFont *)font;
-(NSAttributedString *)attributedStringWithTitle:(NSString *)title titleFont:(UIFont *)titleFont valueFont:(UIFont *)valueFont;
@end
