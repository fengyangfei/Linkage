//
//  CargoTypeViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CargoTypeViewController.h"

@implementation CargoTypeViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
}

-(NSArray *)selectorOptions
{
    NSMutableArray *options = [NSMutableArray array];
    NSMutableDictionary *cargoTypes = [[self class] cargoTypes];
    NSEnumerator *enumerator = cargoTypes.keyEnumerator;
    id key;
    while ((key = [enumerator nextObject])) {
        XLFormOptionsObject *option = [XLFormOptionsObject formOptionsObjectWithValue:key displayText:[cargoTypes objectForKey:key]];
        [options addObject:option];

    }
    [options sortUsingComparator:^NSComparisonResult(XLFormOptionsObject *obj1, XLFormOptionsObject *obj2) {
        return [obj1.valueData compare:obj2.valueData];
    }];
    return options;
}

+(NSMutableDictionary *)cargoTypes
{
    static NSMutableDictionary * _cargoTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cargoTypes = [@{@1:@"CP(20尺)",
                         @2:@"CP(40尺)",
                         @3:@"CP(45尺)",
                         @4:@"HQ(20尺)",
                         @5:@"HQ(45尺)",
                         @6:@"OT(20尺)",
                         @7:@"OT(40尺)",
                         @8:@"FR(20尺)",
                         @9:@"FR(40尺)",
                         @10:@"FR(45尺)",
                         @11:@"GP(20尺)",
                         @12:@"GP(40尺)"} mutableCopy];
    });
    return _cargoTypes;
}

@end
