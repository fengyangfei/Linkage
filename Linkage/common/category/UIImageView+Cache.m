//
//  UIImageView+Cache.m
//  Linkage
//
//  Created by lihaijian on 16/3/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "ImageCacheManager.h"
@implementation UIImageView (Cache)

-(void)imageWithCacheKey:(NSString *)key
{
    WeakSelf
    [[ImageCacheManager sharedManger] queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
        weakSelf.image = image;
    }];
}

@end
