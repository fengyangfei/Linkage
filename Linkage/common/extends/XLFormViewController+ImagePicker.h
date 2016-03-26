//
//  XLFormViewController+ImagePicker.h
//  Linkage
//
//  Created by lihaijian on 16/3/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "SpecialFormSectionDescriptor.h"

@interface XLFormViewController (ImagePicker)
-(BOOL)imageWithTableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCellEditingStyle)imageWithTableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)imageWithTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
