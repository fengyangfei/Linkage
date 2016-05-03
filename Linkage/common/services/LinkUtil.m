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

+ (NSMutableDictionary *)cargoTypes
{
    static NSMutableDictionary * _cargoTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cargoTypes = [@{@0:@"GP(20尺)",
                         @1:@"GP(40尺)",
                         @2:@"HQ(40尺)",
                         @3:@"HQ(45尺)",
                         @4:@"OT(20尺)",
                         @5:@"OT(40尺)",
                         @6:@"FR(20尺)",
                         @7:@"FR(40尺)",
                         @8:@"FR(45尺)",
                         @9:@"R(20尺)",
                         @10:@"R(40尺)"} mutableCopy];
    });
    return _cargoTypes;
}

+ (NSDictionary *)userTypes
{
    static NSDictionary * _userTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userTypes = @{
                         @0:@"厂商管理员",
                         @1:@"承运商管理员"
                        };
    });
    return _userTypes;
}

+ (NSArray *)userTypeOptions
{
    static NSArray * _options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *_mutableOptions = [[NSMutableArray alloc]init];
        [self.userTypes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            XLFormOptionsObject *option = [XLFormOptionsObject formOptionsObjectWithValue:key displayText:obj];
            [_mutableOptions addObject:option];
        }];
        _options = [_mutableOptions copy];
    });
    return _options;
}

@end
