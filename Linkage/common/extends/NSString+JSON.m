//
//  NSString+JSON.m
//  Linkage
//
//  Created by Mac mini on 16/9/9.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)
+(NSString *)jsonString
{
    return [NSString stringWithFormat:@"%@",self];
}
@end
