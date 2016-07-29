//
//  NSDate+Format.m
//  Linkage
//
//  Created by Mac mini on 16/7/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "NSDate+Format.h"
#import "LinkUtil.h"

@implementation NSDate (Format)

- (NSString*)stringFromDate
{
    return [[LinkUtil dateFormatter] stringFromDate:self];
}

- (NSString*)todayStringFromDate
{
    NSDate* nowDate = [NSDate date];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *nowDateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    NSDateComponents *selfDateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    if ([nowDateComponents day] == [selfDateComponents day] && [nowDateComponents month] == [selfDateComponents month] && [selfDateComponents year] == [nowDateComponents year]) { // 今天
        return @"今天";
    }else if ([nowDateComponents day] == [selfDateComponents day] + 1 && [nowDateComponents month] == [selfDateComponents month] && [selfDateComponents year] == [nowDateComponents year]){
        return @"昨天";
    } else {
        return [[LinkUtil dateFormatter] stringFromDate:self];
    }
}

@end
