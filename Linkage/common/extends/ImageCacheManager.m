//
//  ImageCacheManager.m
//  Linkage
//
//  Created by Mac mini on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "ImageCacheManager.h"

@implementation ImageCacheManager

+ (ImageCacheManager *)sharedManger
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc]initWithNamespace:@"link"];
    });
    return instance;
}

@end
