//
//  NSObject+Exchange.m
//  Linkage
//
//  Created by Mac mini on 2017/1/18.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "NSObject+Exchange.h"
#import <objc/runtime.h>

@implementation NSObject (Exchange)
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}
@end
