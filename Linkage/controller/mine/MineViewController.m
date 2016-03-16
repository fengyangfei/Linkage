//
//  MineViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MineViewController.h"
#import "MenuTableViewCell.h"
#import "MenuItem.h"
#import "SettingViewController.h"

@interface MineViewController ()
@end

@implementation MineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"我的"];
    NSArray *array = [MenuItem menuItemsFromTheme];
    
    for (NSArray *subArray in array) {
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        for (MenuItem *menu in subArray) {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMineHeader];
            row.value = menu;
            row.action.viewControllerClass = menu.viewControllerClass;
            [section addFormRow:row];
        }
    }
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
