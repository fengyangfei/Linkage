//
//  VCMineViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCMineViewController.h"
#import "MenuCell.h"
#import "MenuItem.h"
#import "VCSettingViewController.h"
#import "VCFavorTagViewController.h"
#import "VCAdviceViewController.h"
#import "VCHelperViewController.h"
#import "VCAboutViewController.h"
#import "VCMenuPersonalCell.h"
#import "VCPersonalViewController.h"
#import "VCLawViewController.h"

@interface VCMineViewController ()

@end

@implementation VCMineViewController


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
    
    form = [XLFormDescriptor formDescriptorWithTitle:VCThemeString(@"personal")];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:VCFormRowDescriptorTypePesonalHeader];
    row.value = [MenuItem createItemWithTitle:@"头像" andIconName:@"v_user"];
    row.action.viewControllerClass = [VCPersonalViewController class];
    [section addFormRow:row];
    
    //第二组
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    //鸿运（V币）账户
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"vbzh") andIconName:@"money"];
    row.action.viewControllerClass = [VCSettingViewController class];
    [section addFormRow:row];
    
    //分享好友
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"fxhy") andIconName:@"share"];
    row.action.viewControllerClass = [VCSettingViewController class];
    [section addFormRow:row];
    
    //云同步
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"ytb") andIconName:@"cloud"];
    row.action.viewControllerClass = [VCSettingViewController class];
    [section addFormRow:row];
    
    //第三组
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    //设置
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"setting") andIconName:@"setting"];
    row.action.viewControllerClass = [VCSettingViewController class];
    [section addFormRow:row];
    
    //喜好标签
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"perferenceTags") andIconName:@"mark"];
    row.action.viewControllerClass = [VCFavorTagViewController class];
    [section addFormRow:row];
    
    //法律声明
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"flsm") andIconName:@"law"];
    row.action.viewControllerClass = [VCLawViewController class];
    [section addFormRow:row];
    
    //建议反馈
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"advices") andIconName:@"advance"];
    row.action.viewControllerClass = [VCAdviceViewController class];
    [section addFormRow:row];
    
    //帮助说明
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"help") andIconName:@"explain"];
    row.action.viewControllerClass = [VCHelperViewController class];
    [section addFormRow:row];
    
    //关于
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:FormRowDescriptorTypeMine];
    row.value = [MenuItem createItemWithTitle:VCThemeString(@"aboutVcode") andIconName:@"choice"];
    row.action.viewControllerClass = [VCAboutViewController class];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
}

-(void)inviteAction:(XLFormRowDescriptor *)sender
{
    [self deselectFormRow:sender];
}

@end
