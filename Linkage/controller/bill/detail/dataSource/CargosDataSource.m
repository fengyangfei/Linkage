//
//  CargosDataSource.m
//  Linkage
//
//  Created by Mac mini on 16/4/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CargosDataSource.h"

@implementation CargosDataSource

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormRowDescriptor * multivaluedFormRow = [self.form formRowAtIndex:indexPath];
        // end editing
        UIView * firstResponder = [[multivaluedFormRow cellForFormController:self.viewController] findFirstResponder];
        if (firstResponder){
            [self.tableView endEditing:YES];
        }
        [multivaluedFormRow.sectionDescriptor removeFormRowAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.editing = !self.tableView.editing;
            self.tableView.editing = !self.tableView.editing;
        });
    }
}

@end
