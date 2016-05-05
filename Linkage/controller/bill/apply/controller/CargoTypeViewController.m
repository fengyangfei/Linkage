//
//  CargoTypeViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CargoTypeViewController.h"
#import "Cargo.h"
#import "LinkUtil.h"

@implementation CargoTypeViewController
@synthesize rowDescriptor = _rowDescriptor;

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
}

-(NSArray *)selectorOptions
{
    NSMutableArray *options = [NSMutableArray array];
    NSMutableDictionary *cargoTypes = [LinkUtil cargoTypes];
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
    id<XLFormOptionObject> cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];
    if (self.rowDescriptor.value){
        NSInteger index = [[self selectorOptions] formIndexForItem:self.rowDescriptor.value];
        if (index != NSNotFound){
            NSIndexPath * oldSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:oldSelectedIndexPath];
            oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    Cargo *cargoModel = (Cargo *)self.rowDescriptor.value;
    cargoModel.cargoType = [cellObject formValue];
    cargoModel.cargoName = [cellObject formDisplayText];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
