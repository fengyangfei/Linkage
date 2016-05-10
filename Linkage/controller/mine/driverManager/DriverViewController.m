//
//  DriverViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverViewController.h"
#import "Driver.h"
#import "Cargo.h"
#import "DriverUtil.h"
#import "AddDriverViewController.h"
#import "FormDescriptorCell.h"
#import "CargoToDriverCell.h"
#import "Task.h"
#import <Mantle/Mantle.h>

@implementation DriverViewController

-(Class)modelUtilClass
{
    return [DriverUtil class];
}

-(Class)viewControllerClass
{
    return [AddDriverViewController class];
}

//选择行
-(void)didSelectModel:(XLFormRowDescriptor *)chosenRow
{
    XLFormSectionDescriptor *currentSection = self.rowDescriptor.sectionDescriptor;
    id<MTLJSONSerializing,XLFormTitleOptionObject> chosenValue = chosenRow.value;
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverEditDescriporType title:[chosenValue formTitleText]];
    row.value = [Task createWithDriver:(Driver *)chosenValue cargo:(Cargo *)self.rowDescriptor.value];
    [currentSection addFormRow:row beforeRow:self.rowDescriptor];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end