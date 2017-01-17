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
#import "MMSheetView.h"
#import "MMAlertView.h"
#import "VcodeUtil.h"
#import "VCBaseNavViewController.h"
#import "VCThemeManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/SDImageCache.h>
#import <PgyUpdate/PgyUpdateManager.h>

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
    @weakify(self);
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    MenuItem *menuItem;
    
    form = [XLFormDescriptor formDescriptorWithTitle:VCThemeString(@"setting")];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuInfo];
    menuItem = [MenuItem createItemWithTitle:VCThemeString(@"languageSetting") andIconName:@"lan_setting" andClass:nil];
    menuItem.value = [VCThemeManager shareInstance].themeType == VCThemeTypeCN?@"简体中文": @"English";
    row.value = menuItem;
    row.action.formSelector = @selector(languageAction:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuInfo];
    menuItem = [MenuItem createItemWithTitle:VCThemeString(@"searchToolsSetting") andIconName:@"hota" andClass:nil];
    NSNumber *searchKey = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchEngineUserDefaultKey];
    menuItem.value = [VcodeUtil searchName:[searchKey integerValue]];
    row.value = menuItem;
    row.action.formSelector = @selector(searchEngineAction:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuSwitch];
    row.value = [MenuItem createItemWithTitle:@"VPN" andIconName:@"vpn" andClass:nil];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuInfo];
    menuItem = [MenuItem createItemWithTitle:VCThemeString(@"clearCache") andIconName:@"rubbish" andClass:nil];
    NSUInteger totalSize = [[SDImageCache sharedImageCache] getSize];
    menuItem.value = [NSString stringWithFormat:@"%.2fM",(unsigned long)totalSize/(1024.0*1024.0)];
    row.value = menuItem;
    row.action.formSelector = @selector(clearCacheAction:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMenuInfo];
    menuItem = [MenuItem createItemWithTitle:VCThemeString(@"checkUpdate") andIconName:@"refresh" andClass:nil];
    menuItem.value = [NSString stringWithFormat:@"V%@", MAIN_VERSION];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        @strongify(self);
        [self updateAction:sender];
    };
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

#pragma mark - 事件
//检查更新
-(void)updateAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kVCodePgyerAppKey];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

//搜索引擎事件
-(void)searchEngineAction:(XLFormRowDescriptor *)sender
{
    @weakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        @strongify(self);
        MenuItem *menu = (MenuItem *)sender.value;
        menu.value = [VcodeUtil searchName:index];
        [self updateFormRow:sender];
        [[NSUserDefaults standardUserDefaults] setObject:@(index) forKey:kSearchEngineUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSArray *array = @[@(SearchEngineGoogle),@(SearchEngineBaidu), @(SearchEngineBing),@(SearchEngineYahoo),@(SearchEngineHttp)];
    for (NSNumber *ca in array) {
        [items addObject:MMItemMake([VcodeUtil searchName:[ca integerValue]], MMItemTypeNormal, block)];
    }
    [items addObject:MMItemMake(VCThemeString(@"cancel"), MMItemTypeNormal, ^(NSInteger index){
        
    })];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:VCThemeString(@"searchToolsSetting")
                                                         detail:@""
                                                          items:items];
    alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
    [alertView show];
}

//语言切换事件
-(void)languageAction:(XLFormRowDescriptor *)sender
{
    MMPopupItemHandler block = ^(NSInteger index){
        if ([VCThemeManager shareInstance].themeType != index) {
            [VCThemeManager shareInstance].themeType = index;
            [VcodeUtil refreshApp];
        }
    };
    NSMutableArray *items = [[NSMutableArray alloc]init];
    [items addObject:MMItemMake(@"简体中文", MMItemTypeNormal, block)];
    [items addObject:MMItemMake(@"English", MMItemTypeNormal, block)];
    [items addObject:MMItemMake(VCThemeString(@"cancel"), MMItemTypeNormal, ^(NSInteger index){
        
    })];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"切换语言"
                                                         detail:@""
                                                          items:items];
    alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
    [alertView show];
}

#pragma mark - XLFormDescriptorDelegate
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
}



-(void)clearCacheAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [SVProgressHUD show];
    MenuItem *menuItem = row.value;
    menuItem.value = @"0.00M";
    [self reloadFormRow:row];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD dismiss];
    }];
}

-(void)shareAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
}


-(void)aboutUSAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
}

@end
