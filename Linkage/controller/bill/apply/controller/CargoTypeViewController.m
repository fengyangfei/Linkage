//
//  CargoTypeViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CargoTypeViewController.h"
#import "CargoModel.h"

@implementation CargoTypeViewController
@synthesize rowDescriptor = _rowDescriptor;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];
    if (self.rowDescriptor.value){
        NSInteger index = [[self selectorOptions] formIndexForItem:self.rowDescriptor.value];
        if (index != NSNotFound){
            NSIndexPath * oldSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:oldSelectedIndexPath];
            oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    CargoModel *cargoModel = (CargoModel *)self.rowDescriptor.value;
    cargoModel.cargoType = cellObject;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
