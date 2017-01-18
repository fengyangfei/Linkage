//
//  VCPersonalViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/17.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCPersonalViewController.h"
#import "VCLoginUser.h"
#import "UIViewController+TRImagePicker.h"
#import "ImageCacheManager.h"
#import "LinkUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define RowUI row.cellStyle = UITableViewCellStyleValue1;\
[row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
[row.cellConfig setObject:@(UITableViewCellSelectionStyleNone) forKey:@"selectionStyle"];

@interface VCPersonalViewController ()

@end

@implementation VCPersonalViewController

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
    
    VCLoginUser *user = [VCLoginUser loginUserInstance];
    
    form = [XLFormDescriptor formDescriptorWithTitle:VCThemeString(@"setting")];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:VCThemeString(@"head")];
    RowUI
    row.action.formSelector = @selector(uploadAvatar:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"nicheng" rowType:XLFormRowDescriptorTypeText title:VCThemeString(@"nicheng")];
    row.value = user.userName;
    row.noValueDisplayText = VCThemeString(@"nicheng_ed");
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phone" rowType:XLFormRowDescriptorTypeText title:VCThemeString(@"phonetext")];
    row.value = user.mobile;
    row.noValueDisplayText = VCThemeString(@"phone_ed");
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"sex" rowType:XLFormRowDescriptorTypeText title:VCThemeString(@"sex")];
    row.value = user.gender == Female? @"男":@"女";
    row.noValueDisplayText = VCThemeString(@"sex_ed");
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"country" rowType:XLFormRowDescriptorTypeText title:VCThemeString(@"country")];
    row.value = user.country;
    row.noValueDisplayText = VCThemeString(@"country_ed");
    [section addFormRow:row];
    
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:VCThemeString(@"ok") style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = BackgroundColor;
}

-(void)uploadAvatar:(XLFormRowDescriptor *)row
{
    @weakify(row);
    [self addSignalPhoto:^(UIImage *image, NSString *fileName) {
        @strongify(row);
        row.value = fileName;
        [[ImageCacheManager sharedManger] diskImageExistsWithKey:fileName completion:^(BOOL isInCache) {
            [LinkUtil uploadWithUrl:UpdateUserPicUrl image:UIImageJPEGRepresentation(image, 0.75) name:fileName success:^(id responseObject) {
                //LoginUser *user = [VCLoginUser loginUserInstance];
                //if (responseObject[@"result"][@"icon"]) {
                //    user.icon = responseObject[@"result"][@"icon"];
                //}
                //[user save];
            }];
            if (!isInCache) {
                [[ImageCacheManager sharedManger] storeImage:image forKey:fileName];
            }
        }];
    }];
}

-(void)saveAction:(id)sender
{
    NSDictionary *formValues = [self formValues];
    VCLoginUser *loginUser = [[VCLoginUser alloc]init];
    loginUser.mobile = formValues[@"phone"];
    loginUser.gender = [formValues[@"sex"] integerValue];
    loginUser.userName = formValues[@"nicheng"];
    loginUser.country = formValues[@"country"];
    [loginUser save];
}

@end
