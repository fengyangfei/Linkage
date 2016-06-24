//
//  AddressViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressUtil.h"
#import "LoginUser.h"
#import "AddAddressViewController.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AddressViewController()
@property (nonatomic, assign) AddressType addressType;
@end

@implementation AddressViewController

-(instancetype)initWithControllerType:(ControllerType)controllerType addressType:(AddressType)addType
{
    self = [super initWithControllerType:controllerType];
    if (self) {
        self.addressType = addType;
    }
    return self;
}

-(Class)modelUtilClass
{
    return [AddressUtil class];
}

-(Class)viewControllerClass
{
    return [AddAddressViewController class];
}

-(void)setupNavigationItem
{
    UIBarButtonItem *addBtn = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItem = addBtn;
}

- (void)setupData
{
    WeakSelf
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ AND title = %@", [LoginUser shareInstance].cid, @(self.addressType)];
    [self.modelUtilClass queryModelsFromDataBase:predicate completion:^(NSArray *models) {
        if (models.count > 0) {
            [weakSelf initializeForm:models];
        }
    }];
}

-(void)didSelectModel:(XLFormRowDescriptor *)chosenRow
{
    id<MTLJSONSerializing,XLFormTitleOptionObject> chosenValue = chosenRow.value;
    self.rowDescriptor.value = [chosenValue formDisplayText];
    [self.navigationController popViewControllerAnimated:YES];
}
@end