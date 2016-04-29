//
//  CargosDataSource.m
//  Linkage
//
//  Created by Mac mini on 16/4/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CargosDataSource.h"
#import "DriverViewController.h"

@implementation CargosDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

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
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        UIViewController<XLFormRowDescriptorViewController> *controller = [[DriverViewController alloc]initWithControllerType:ControllerTypeQuery];
        XLFormRowDescriptor * multivaluedFormRow = [self.form formRowAtIndex:indexPath];
        controller.rowDescriptor = multivaluedFormRow;
        [self.viewController.navigationController pushViewController:controller animated:YES];
    }
}

@end
