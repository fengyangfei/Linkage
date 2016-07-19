//
//  MineViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MineViewController.h"
#import "MenuCell.h"
#import "MenuItem.h"
#import "SettingViewController.h"
#import "LoginUser.h"
#import "YGRestClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

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
            NSString *rowTypeIndentifier = menu.type == MenuItemTypeHeader ? FormRowDescriptorTypeMineHeader: FormRowDescriptorTypeMine;
            row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:rowTypeIndentifier];
            row.value = menu;
            if (menu.viewControllerClass) {
                row.action.viewControllerClass = menu.viewControllerClass;
            }else if (menu.selectorName){
                row.action.formSelector = NSSelectorFromString(menu.selectorName);
            }
            [section addFormRow:row];
        }
    }
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
    [SVProgressHUD show];
    [[YGRestClient sharedInstance] postForObjectWithUrl:GenInvitecodeUrl form:[LoginUser shareInstance].baseHttpParameter success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString *shareUrl = responseObject[@"URL"];
        [WXApiRequestHandler sendLinkURL:shareUrl TagName:@"邀请员工" Title:@"邀请员工" Description:@"邀请员工加入" ThumbImage:[UIImage imageNamed:@"logo"] InScene:WXSceneSession];
    } failure:^(NSError *error) {
        
    }];
}


@end
