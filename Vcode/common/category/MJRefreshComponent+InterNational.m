//
//  MJRefreshComponent+InterNational.m
//  Linkage
//
//  Created by Mac mini on 2017/1/18.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "MJRefreshComponent+InterNational.h"
#import <objc/runtime.h>
static inline void af_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@implementation MJRefreshComponent (InterNational)
+(void)load
{
    af_swizzleSelector(self, @selector(localizedStringForKey:), @selector(vc_localizedStringForKey:));
}

- (NSString *)vc_localizedStringForKey:(NSString *)key{
    return VCThemeString(key);
}
@end
