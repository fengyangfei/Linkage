//
//  SettingViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/1.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SettingViewController.h"
#import "DateAndTimeValueTrasformer.h"
#import "ImageCacheManager.h"
#import "UMSocial.h"
#import "LoginUser.h"
#import "YGRestClient.h"
#import "LoginBaseViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TutorialController.h"
#import <SDWebImage/SDImageCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <PgyUpdate/PgyUpdateManager.h>


#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
row.cellStyle = UITableViewCellStyleValue1;
#define RowPlaceHolderUI(str) [row.cellConfigAtConfigure setObject:str forKey:@"detailTextLabel.text"];
#define RowAccessoryUI [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];

@interface SettingViewController ()<UMSocialUIDelegate>

@end

@implementation SettingViewController

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
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"系统设置"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"receive_sms" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"接收平台短信"];
    row.value = @([LoginUser receiveSms]);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"receive_email" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"接收平台邮件"];
    row.value = @([LoginUser receiveEmail]);
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"clearCache" rowType:XLFormRowDescriptorTypeButton title:@"清除缓存"];
    NSUInteger totalSize = [[SDImageCache sharedImageCache] getSize];
    row.value = [NSString stringWithFormat:@"%.2fM",(unsigned long)totalSize/(1024.0*1024.0)];
    RowUI
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf clearCacheAction:sender];
    };
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"share" rowType:XLFormRowDescriptorTypeButton title:@"分享好友"];
    RowUI
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf shareAction:sender];
    };
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"update" rowType:XLFormRowDescriptorTypeButton title:@"版本更新"];
    row.value = [NSString stringWithFormat:@"当前版本 V%@", MAIN_VERSION];
    RowUI
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf updateAction:sender];
    };
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"about" rowType:XLFormRowDescriptorTypeButton title:@"关于我们"];
    RowUI
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf aboutUSAction:sender];
    };
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"退出"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf logoutAction];
    };
    [section addFormRow:row];
    
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
}

//退出
-(void)logoutAction
{
    [LoginUser clearUserInfo];
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    if ([rootViewController isKindOfClass:[TutorialController class]] || [rootViewController isKindOfClass:[LoginBaseViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

-(void)presentSns
{
    NSArray *shareArray = [NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina,UMShareToWechatSession,nil];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUmengSocialAppKey
                                      shareText:kAppInfomation
                                     shareImage:[UIImage imageNamed:@"logo"]
                                shareToSnsNames:shareArray
                                       delegate:self];
}

#pragma mark - XLFormDescriptorDelegate
-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    if ([formRow.tag isEqualToString:@"receive_sms"]) {
        [LoginUser setreceiveSms:[newValue boolValue]];
    }else if ([formRow.tag isEqualToString:@"receive_email"]) {
        [LoginUser setreceiveEmail:[newValue boolValue]];
    }else{
        [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    }
}

-(void)syncToServer
{
    NSDictionary *parameter = @{};
    [[YGRestClient sharedInstance] postForObjectWithUrl:SystemSettingUrl form:parameter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

-(void)clearCacheAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [SVProgressHUD show];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD dismiss];
        NSUInteger totalSize = [[SDImageCache sharedImageCache] getSize];
        row.value = [NSString stringWithFormat:@"%.2fM",(unsigned long)totalSize/(1024.0*1024.0)];
    }];
}

-(void)shareAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [self presentSns];
}

-(void)updateAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppKey];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

-(void)aboutUSAction:(XLFormRowDescriptor *)row
{
    [self deselectFormRow:row];
}

@end
