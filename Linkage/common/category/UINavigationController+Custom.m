//
//  UINavigationController+Custom.m
//  Linkage
//
//  Created by lihaijian on 16/5/5.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "UINavigationController+Custom.h"
#import <objc/runtime.h>

static inline void af_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@implementation UINavigationController (Custom)


+(void)load
{
    af_swizzleSelector(self, @selector(popViewControllerAnimated:), @selector(custom_popViewControllerAnimated:));
}

- (UIViewController *)custom_popViewControllerAnimated:(BOOL)animated
{
    return [self custom_popViewControllerAnimated:animated];
}

@end
