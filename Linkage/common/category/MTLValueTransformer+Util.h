//
//  MTLValueTransformer+Util.h
//  Linkage
//
//  Created by Mac mini on 16/9/14.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MTLValueTransformer (Util)

+ (MTLValueTransformer *)dateTransformer;
+ (MTLValueTransformer *)numberTransformer;
@end
