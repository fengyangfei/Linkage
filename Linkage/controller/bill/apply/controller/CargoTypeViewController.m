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
    for (int i = 0; i < 5; i++) {
        NSString *title = [NSString stringWithFormat:@"货柜类型%d",i+1];
        XLFormOptionsObject *option = [XLFormOptionsObject formOptionsObjectWithValue:@(i) displayText:title];
        [options addObject:option];
    }
    return options;
}

@end
