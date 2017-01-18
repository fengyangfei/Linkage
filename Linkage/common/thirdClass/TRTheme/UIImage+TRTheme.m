//
//  UIImage+TRTheme.m
//  YGTravel
//
//  Created by Mac mini on 16/1/11.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "UIImage+TRTheme.h"
#import "TRThemeManager.h"
#import <objc/runtime.h>

@implementation UIImage (TRTheme)
+ (UIImage *)tr_imageNamed:(NSString *)name
{
    NSRange range = [name rangeOfString:@"."];
    NSString *typeExt = range.location == NSNotFound? @"png": nil;
    NSBundle *bundle = [TRThemeManager shareInstance].themeBundle;
    NSString *path = [bundle pathForResource:name ofType:typeExt];
    if (!path) {
        NSString *retinaName = [NSString stringWithFormat:@"%@@2x", name];
        path = [bundle pathForResource:retinaName ofType:typeExt];
    }
    return [self imageWithData:[NSData dataWithContentsOfFile:path]
                  scale:isRetinaFilePath(path) ? 2.0f : 1.0f];
}

inline static BOOL isRetinaFilePath(NSString *path)
{
    NSRange retinaSuffixRange = [[path lastPathComponent] rangeOfString:@"@2x" options:NSCaseInsensitiveSearch];
    return retinaSuffixRange.length && retinaSuffixRange.location != NSNotFound;
}

@end
