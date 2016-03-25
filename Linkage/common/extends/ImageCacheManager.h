//
//  ImageCacheManager.h
//  Linkage
//
//  Created by Mac mini on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <SDWebImage/SDImageCache.h>

@interface ImageCacheManager : SDImageCache

+ (ImageCacheManager *)sharedManger;

@end
