//
//  FavoriteViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/24.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FavoriteViewController.h"
#import "Favorite.h"
#import "FavoriteUtil.h"
#import "FavoriteViewController.h"
#import "MainTableViewCell.h"

@implementation FavoriteViewController

-(Class)modelUtilClass
{
    return [FavoriteUtil class];
}

-(Class)viewControllerClass
{
    return [FavoriteViewController class];
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
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [form addFormSection:section];
    
    for (Favorite *model in models) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:CompanyDescriporType];
        row.value = model;
        [section addFormRow:row];
    }
    self.form = form;
}

@end
