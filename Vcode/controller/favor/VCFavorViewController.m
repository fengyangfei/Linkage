//
//  VCFavorViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorViewController.h"
#import "VCFavorCell.h"
#import "VCFavorUtil.h"

@interface VCFavorViewController ()

@end

@implementation VCFavorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(Class)modelUtilClass
{
    return [VCFavorUtil class];
}

- (void)queryDataFromServer:(void(^)(void))block
{
    block();
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
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:VCFavorDescriporType];
        row.value = model;
        [section addFormRow:row];
    }
    
    [self setForm:form];
}

@end
