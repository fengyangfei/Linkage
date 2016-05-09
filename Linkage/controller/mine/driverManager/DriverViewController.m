//
//  DriverViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverViewController.h"
#import "Driver.h"
#import "DriverUtil.h"
#import "AddDriverViewController.h"
#import "FormDescriptorCell.h"
#import "DriverInfoCell.h"
#import "CargoToDriver.h"
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
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverInfoDescriporType title:[chosenValue formTitleText]];
    row.value = [[CargoToDriver alloc]initWithDriver:(Driver *)chosenValue cargo:nil];
    [currentSection addFormRow:row beforeRow:self.rowDescriptor];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end