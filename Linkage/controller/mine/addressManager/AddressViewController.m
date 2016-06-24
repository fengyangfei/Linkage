//
//  AddressViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressUtil.h"
#import "AddAddressViewController.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation AddressViewController

-(Class)modelUtilClass
{
    return [AddressUtil class];
}

-(Class)viewControllerClass
{
    return [AddAddressViewController class];
}

-(void)setupNavigationItem
{
    UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
}

-(void)didSelectModel:(XLFormRowDescriptor *)chosenRow
{
    id<MTLJSONSerializing,XLFormTitleOptionObject> chosenValue = chosenRow.value;
    self.rowDescriptor.value = [chosenValue formDisplayText];
    [self.navigationController popViewControllerAnimated:YES];
}
@end