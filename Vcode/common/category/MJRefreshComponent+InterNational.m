//
//  MJRefreshComponent+InterNational.m
//  Linkage
//
//  Created by Mac mini on 2017/1/18.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "MJRefreshComponent+InterNational.h"
#import "NSObject+Exchange.h"

@implementation MJRefreshComponent (InterNational)
+(void)load
{
    //[self exchangeInstanceMethod1:@selector(localizedStringForKey:) method2:@selector(vc_localizedStringForKey:)];
}

- (NSString *)vc_localizedStringForKey:(NSString *)key{
    return VCThemeString(key);
}
@end
