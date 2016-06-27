//
//  AddAddressViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddAddressViewController.h"
#import "Address.h"
#import "AddressModel.h"
#import "AddressUtil.h"
#import "LinkUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation AddAddressViewController
@synthesize rowDescriptor = _rowDescriptor;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm:nil];
    }
    return self;
}

- (void)initializeForm:(Address *)address
{
    XLFormDescriptor *form = [self createForm:address];
    self.form = form;
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self initializeForm:rowDescriptor.value];
}

- (XLFormDescriptor *)createForm:(Address *)address
{
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"添加常用地址"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"addOption" rowType:XLFormRowDescriptorTypeSelectorPush title:@"地址类型"];
    if (address && address.title) {
        row.value = [XLFormOptionsObject formOptionsObjectWithValue:address.title displayText:[[LinkUtil addressTypes] objectForKey:address.title]];
    }
    row.selectorOptions = [LinkUtil addressTypeOptions];
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"address" rowType:XLFormRowDescriptorTypeTextView title:@"地址"];
    row.value = address?address.address:@"";
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    if (!address) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"保存"];
        row.action.formBlock  = ^(XLFormRowDescriptor * sender){
            [weakSelf submitForm:sender];
        };
    }else{
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"修改"];
        row.action.formBlock  = ^(XLFormRowDescriptor * sender){
            [weakSelf submitForm:sender];
        };
    }
    [section addFormRow:row];
    
    return form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
}

-(void)submitForm:(XLFormRowDescriptor *)row
{
    WeakSelf
    [self deselectFormRow:row];
    NSArray *errors = [self formValidationErrors];
    if (errors && errors.count > 0) {
        [self showFormValidationError:errors[0]];
        return;
    }
    NSDictionary *formValues = [self formValues];
    Address *model = (Address *)[AddressUtil modelFromXLFormValue:formValues];
    if (_rowDescriptor.value) {
        model.addressId = ((Address *)_rowDescriptor.value).addressId;
    }
    //同步到服务端
    [SVProgressHUD show];
    [AddressUtil syncToServer:model success:^(id responseData) {
        NSString *addressId = responseData[@"address_id"];
        if (addressId) {
            model.addressId = addressId;
            //同步到数据库
            StrongSelf
            [AddressUtil syncToDataBase:model completion:^{
                [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                    [SVProgressHUD dismiss];
                }];
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}
@end
