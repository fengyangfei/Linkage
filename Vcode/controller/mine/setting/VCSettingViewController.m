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
#import "MenuCell.h"
#import "VCMenuInfoCell.h"
#import <SDWebImage/SDImageCache.h>

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
    MenuItem *menuItem;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"设置"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuInfo];
    menuItem = [MenuItem createItemWithTitle:@"语言设置" andIconName:@"lan_setting" andClass:nil];
    menuItem.value = @"简体中文";
    row.value = menuItem;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:@"常用搜索引擎" andIconName:@"hota" andClass:nil];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuSwitch];
    row.value = [MenuItem createItemWithTitle:@"VPN" andIconName:@"vpn" andClass:nil];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuInfo];
    menuItem = [MenuItem createItemWithTitle:@"清除缓存" andIconName:@"rubbish" andClass:nil];
    NSUInteger totalSize = [[SDImageCache sharedImageCache] getSize];
    menuItem.value = [NSString stringWithFormat:@"%.2fM",(unsigned long)totalSize/(1024.0*1024.0)];
    row.value = menuItem;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuInfo];
    menuItem = [MenuItem createItemWithTitle:@"检查更新" andIconName:@"refresh" andClass:nil];
    menuItem.value = [NSString stringWithFormat:@"V%@", MAIN_VERSION];
    row.value = menuItem;
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
