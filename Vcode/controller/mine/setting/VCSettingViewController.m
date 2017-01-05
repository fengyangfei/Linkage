//
//  VCSettingViewController.m
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCSettingViewController.h"
#import "VCMenuSwitchCell.h"
#import "MenuItem.h"

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
row.cellStyle = UITableViewCellStyleValue1;
#define RowPlaceHolderUI(str) [row.cellConfigAtConfigure setObject:str forKey:@"detailTextLabel.text"];
#define RowAccessoryUI [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
@interface VCSettingViewController ()

@end

@implementation VCSettingViewController
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
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuSwitch];
    row.value = [MenuItem createItemWithTitle:@"VPN" andIconName:@"vpn" andClass:nil];
    [section addFormRow:row];
    
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
}


#pragma mark - XLFormDescriptorDelegate
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
}



-(void)clearCacheAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [self reloadFormRow:row];
}

-(void)shareAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
}

-(void)updateAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
}

-(void)aboutUSAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
}

@end
