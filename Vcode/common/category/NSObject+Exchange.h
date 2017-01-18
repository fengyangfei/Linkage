//
//  NSObject+Exchange.h
//  Linkage
//
//  Created by Mac mini on 2017/1/18.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Exchange)
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2;
+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2;

@end
