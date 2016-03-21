//
//  SettingViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/1.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SettingViewController.h"
#import "DateAndTimeValueTrasformer.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"系统设置"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"getmessage" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"接收平台短信"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"getemail" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"接收平台邮件"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"clearCache" rowType:XLFormRowDescriptorTypeText title:@"清除缓存"];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"share" rowType:XLFormRowDescriptorTypeButton title:@"分享好友"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"update" rowType:XLFormRowDescriptorTypeButton title:@"版本更新"];
    [section addFormRow:row];

    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"about" rowType:XLFormRowDescriptorTypeButton title:@"关于我们"];
    [section addFormRow:row];
    
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    
}

-(void)cancelPressed:(UIBarButtonItem * __unused)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)savePressed:(UIBarButtonItem * __unused)button
{
}

@end
