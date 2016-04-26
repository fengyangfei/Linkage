//
//  BillDetailViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillDetailViewController.h"
#import "XLFormDataSource.h"
#import "LoginUser.h"
#import "Order.h"
#import "OrderUtil.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "DriverInfoCell.h"
#import "LinkUtil.h"

@interface BillDetailViewController()<XLFormRowDescriptorViewController>
@property (nonatomic, strong) XLFormDataSource *detailDS;
@property (nonatomic, strong) XLFormDataSource *historyDS;
@end

@implementation BillDetailViewController
@synthesize rowDescriptor = _rowDescriptor;

-(void)dealloc
{
    self.detailDS = nil;
    self.historyDS = nil;
    self.leftTableView.delegate = nil;
    self.rightTableView.dataSource = nil;
}

-(void)viewDidLoad
{
    WeakSelf
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setupData];
    
    Order *order = self.rowDescriptor.value;
    //if (order.objStatus == Transient) {
        [OrderUtil queryOrderFromServer:order completion:^(Order *result) {
            [weakSelf.detailDS setForm:[self createDetailForm:result]];
        }];
    //}

}

-(void)setupData
{
    [self refreshLeftTable];
    [self refreshRightTable];
}

-(void)refreshLeftTable
{
    self.detailDS = [[XLFormDataSource alloc]initWithViewController:self tableView:self.leftTableView];
    self.leftTableView.dataSource = self.detailDS;
    self.leftTableView.delegate = self.detailDS;
    [self.detailDS setForm:[self createDetailForm:self.rowDescriptor.value]];
}

-(void)refreshRightTable
{
    self.historyDS = [[XLFormDataSource alloc]initWithViewController:self tableView:self.rightTableView];
    self.rightTableView.dataSource = self.historyDS;
    self.rightTableView.delegate = self.historyDS;
    [self.historyDS setForm:[self createHistoryForm]];
}

-(XLFormDescriptor *)createDetailForm:(Order *)order
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"订单号"];
    row.value = order.orderId;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"接单承运商"];
    Company *company = [LoginUser findCompanyById:order.companyId];
    row.value = company ? company.name :@"";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    row.value = order? order.takeAddress:@"";
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"到厂时间"];
    row.value = order? [[LinkUtil dateFormatter] stringFromDate:order.deliverTime]: @"";
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"送货地址"];
    row.value = order? order.deliveryAddress:@"";
    [section addFormRow:row];
    
    if ([order isKindOfClass:[ExportOrder class]]) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"头程公司"];
        row.value = order? ((ExportOrder *)order).shipCompany :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"头程船名"];
        row.value = order? ((ExportOrder *)order).shipName :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"是否约好"];
        if (order && ((ExportOrder *)order).isBookCargo) {
            row.value = @"是";
        }else{
            row.value = @"否";
        }
        [section addFormRow:row];
    }
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"是否转关"];
    row.value = @YES;
    if (order && order.isTransferPort) {
        row.value = @"是";
    }else{
        row.value = @"否";
    }
    [section addFormRow:row];
    
    return form;
}

-(XLFormDescriptor *)createHistoryForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"货柜A"];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverInfoDescriporType];
        [section addFormRow:row];
    }
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"货柜B"];
    [form addFormSection:section];
    
    for (int i = 0; i < 5; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverInfoDescriporType];
        [section addFormRow:row];
    }
    
    return form;
}

#pragma mark - 重写
- (HMSegmentedControl *)segmentedControl
{
    HMSegmentedControl *segmentedControl = [super segmentedControl];
    segmentedControl.sectionTitles = @[@"订单详情", @"货柜详情"];
    return segmentedControl;
}

@end
