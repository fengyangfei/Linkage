//
//  LinkUtil.m
//  Linkage
//
//  Created by Mac mini on 16/4/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LinkUtil.h"

@implementation LinkUtil

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
    });
    return dateFormatter;
}

@end
