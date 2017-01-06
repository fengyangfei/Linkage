//
//  UINavigationItem+Spacing.m
//  Linkage
//
//  Created by Mac mini on 2017/1/6.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "UINavigationItem+Spacing.h"
#import <objc/runtime.h>

@implementation UINavigationItem (Spacing)

+(void)load
{
    method_exchangeImplementations(class_getClassMethod(self, @selector(setLeftBarButtonItem:)), class_getClassMethod(self, @selector(mySetLeftBarButtonItem:)));
}
-(UIBarButtonItem *)space
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -10.0f;
    return fixedSpace;
}

-(void)mySetLeftBarButtonItem:(UIBarButtonItem *)barButton
{
    NSArray *barButtons = nil;
    barButtons = @[[self space],barButton];
    [self setLeftBarButtonItems:barButtons];
}

@end
