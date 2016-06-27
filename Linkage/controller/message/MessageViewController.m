//
//  MessageViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableCell.h"
#import "MessageUtil.h"

@implementation MessageViewController

-(Class)modelUtilClass
{
    return [MessageUtil class];
}

-(void)setupNavigationItem
{
}

- (void)initializeForm:(NSArray *)models
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    for (id model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:MessageDescriporType];
        row.value = model;
        [section addFormRow:row];
    }
    self.form = form;
}
@end