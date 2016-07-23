//
//  CompanyInfoViewController.m
//  Linkage
//
//  Created by Mac mini on 16/6/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "Company.h"
#import "CompanyUtil.h"
#import "LoginUser.h"
#import "CycleScrollCell.h"
#import <Mantle/NSDictionary+MTLJSONKeyPath.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define RowUI row.cellStyle = UITableViewCellStyleValue1;\
[row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
[row.cellConfig setObject:@(UITableViewCellSelectionStyleNone) forKey:@"selectionStyle"];

@interface CompanyInfoViewController ()

@end

@implementation CompanyInfoViewController
@synthesize rowDescriptor = _rowDescriptor;

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
    XLFormDescriptor *form = [self createForm:nil];
    self.form = form;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 16)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self setupData];
}

-(void)setupData
{
    WeakSelf
    Favorite *favorite = self.rowDescriptor.value;
    if (favorite) {
        [CompanyUtil queryModelFromServer:favorite completion:^(id<MTLJSONSerializing> result) {
            XLFormDescriptor *form = [self createForm:(Company *)result];
            [weakSelf setForm:form];
        }];
    }
    
    Company *company = [Company shareInstance];
    if(company){
    }
}

-(XLFormDescriptor *)createForm:(Company *)company
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    if(StringIsNotEmpty(company.images)){
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        
        NSArray *images = [company.images componentsSeparatedByString:@";"];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for (NSString *imageUrl in images) {
            Advert *ad = [[Advert alloc]init];
            ad.icon = imageUrl;
            [imageArray addObject:ad];
        }
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:CycleScrollDescriporRowType];
        row.value = imageArray;
        [section addFormRow:row];
    }
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"company_name" rowType:XLFormRowDescriptorTypeButton title:@"企业名称"];
    RowUI
    if (company) {
        row.value = company.companyName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"description" rowType:XLFormRowDescriptorTypeButton title:@"企业简介"];
    RowUI
    if (company) {
        row.value = company.introduction;
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"contact_name" rowType:XLFormRowDescriptorTypeButton title:@"企业联系人"];
    RowUI
    if (company) {
        row.value = company.contactName;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"contact_address" rowType:XLFormRowDescriptorTypeButton title:@"企业地址"];
    RowUI
    if (company) {
        row.value = company.address;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeButton title:@"企业邮箱"];
    RowUI
    if (company) {
        row.value = company.email;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"fax" rowType:XLFormRowDescriptorTypeButton title:@"传真"];
    RowUI
    if (company) {
        row.value = company.fax;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"url" rowType:XLFormRowDescriptorTypeButton title:@"企业网址"];
    RowUI
    if (company) {
        row.value = company.url;
    }
    [section addFormRow:row];
    
    if (company && company.servicePhone2) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"联系电话"];
        RowUI
        row.value = company.servicePhone2;
        [section addFormRow:row];
    }
    
    if (company && company.servicePhone3) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"联系电话"];
        RowUI
        row.value = company.servicePhone3;
        [section addFormRow:row];
    }
    
    if (company && company.servicePhone4) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"联系电话"];
        RowUI
        row.value = company.servicePhone4;
        [section addFormRow:row];
    }
    
    return form;
}

#pragma mark - 按钮事件
-(void)collectAction:(id)sender
{
    Favorite *favorite = self.rowDescriptor.value;
    NSDictionary *parameter = [favorite httpParameterForDetail];
    [[YGRestClient sharedInstance] postForObjectWithUrl:AddFavoriteUrl form:parameter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"收藏失败"];
    }];
}

@end
