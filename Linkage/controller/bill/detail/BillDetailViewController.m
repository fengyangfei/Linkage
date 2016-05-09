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
#import "Cargo.h"
#import "CargoToDriver.h"
#import "OrderUtil.h"
#import "Driver.h"
#import "CargoToDriverCell.h"
#import "LinkUtil.h"
#import "SpecialFormSectionDescriptor.h"
#import "DriverViewController.h"
#import "CargosDataSource.h"
#import "YGRestClient.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
@interface BillDetailViewController()<XLFormRowDescriptorViewController>
@property (nonatomic, strong) XLFormDataSource *detailDS;
@property (nonatomic, strong) CargosDataSource *cargosDataSource;
@end

@implementation BillDetailViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize leftTableView = _leftTableView;
@synthesize rightTableView = _rightTableView;

-(void)dealloc
{
    _detailDS = nil;
    _cargosDataSource = nil;
}

-(void)viewDidLoad
{
    WeakSelf
    [super viewDidLoad];
    Order *order = self.rowDescriptor.value;
    [self setupData:order];
    if (order.orderId) {
        self.title = @"订单详情";
        [SVProgressHUD show];
        [OrderUtil queryModelFromServer:order completion:^(Order *result) {
            [OrderUtil syncToDataBase:result completion:nil];
            [weakSelf setupData:result];
            [SVProgressHUD dismiss];
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
        }];
    }
}

-(void)setupData:(Order *)order
{
    if (_detailDS) {
        [_detailDS setForm:[self createDetailForm:order]];
    }
    if (_cargosDataSource) {
        if([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin){
            [_cargosDataSource setForm:[self createCargosEditForm:order]];
        }else{
            [_cargosDataSource setForm:[self createCargosInfoForm:order]];
        }
    }
}

#pragma mark - 创建Form对象
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
    row.value = company ? company.companyName :@"";
    [section addFormRow:row];
    
    for (Cargo *cargo in order.cargos) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:[LinkUtil.cargoTypes objectForKey:cargo.cargoType]];
        if ([order isKindOfClass:[ImportOrder class]]) {
            row.value = cargo.cargoNo;
        }else{
            row.value = cargo.cargoCount;
        }
        [section addFormRow:row];
    }
    
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
    
    if([order isKindOfClass:[ImportOrder class]]) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"柜号"];
        row.value = order? ((ImportOrder *)order).cargoNo :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"报关行联系人"];
        row.value = order? ((ImportOrder *)order).customsBroker :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"联系人电话"];
        row.value = order? ((ImportOrder *)order).customsHouseContact :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"二程公司"];
        row.value = order? ((ImportOrder *)order).cargoCompany :@"";
        [section addFormRow:row];
    }
    
    if([order isKindOfClass:[SelfOrder class]]) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"报关时间"];
        row.value = order? [[LinkUtil dateFormatter] stringFromDate:((SelfOrder *)order).customsIn] :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"提货时间"];
        row.value = order? [[LinkUtil dateFormatter] stringFromDate:((SelfOrder *)order).cargoTakeTime] :@"";
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

//可编辑的form
-(XLFormDescriptor *)createCargosEditForm:(Order *)order
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    
    for (Cargo *cargo in order.cargos) {
        NSString *cargoTitle = [LinkUtil.cargoTypes objectForKey:cargo.cargoType];
        section = [XLFormSectionDescriptor formSectionWithTitle:cargoTitle sectionOptions:XLFormSectionOptionCanInsert|XLFormSectionOptionCanDelete];
        section.multivaluedTag = [NSUUID UUID].UUIDString;
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"添加司机"];
        RowUI
        row.value = cargo;
        row.action.formSelector = @selector(addDriverRow:);
        [section addFormRow:row];
    }
    
    if (order.cargos.count > 0) {
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"确定"];
        row.action.formSelector = @selector(allocateTask:);
        [section addFormRow:row];
    }
    
    return form;
}

//查看详情的form
-(XLFormDescriptor *)createCargosInfoForm:(Order *)order
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    form.disabled = YES;
    
    for (Cargo *cargo in order.cargos) {
        NSString *cargoTitle = [LinkUtil.cargoTypes objectForKey:cargo.cargoType];
        section = [XLFormSectionDescriptor formSectionWithTitle:cargoTitle];
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:DriverInfoDescriporType];
        RowUI
        row.value = [[CargoToDriver alloc]initWithDriver:nil cargo:cargo];
        [section addFormRow:row];
    }
    return form;
}

#pragma mark - 事件处理
//添加司机
-(void)addDriverRow:(XLFormRowDescriptor *)row
{
    UIViewController<XLFormRowDescriptorViewController> *controller = [[DriverViewController alloc]initWithControllerType:ControllerTypeQuery];
    controller.rowDescriptor = row;
    [self.navigationController pushViewController:controller animated:YES];
}

//分配任务给司机
-(void)allocateTask:(XLFormRowDescriptor *)row
{
    NSMutableArray *cargos = [[NSMutableArray alloc]init];
    NSDictionary *formValues = [self.cargosDataSource.form formValues];
    [formValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id drivers, BOOL * stop) {
        if ([drivers isKindOfClass:[NSArray class]]) {
            [drivers enumerateObjectsUsingBlock:^(id driver, NSUInteger idx, BOOL * stop) {
                if ([driver isKindOfClass:[CargoToDriver class]]) {
                    [cargos addObject:@{
                                        @"driver_id":((CargoToDriver *)driver).driverId,
                                        @"cargo_type":((CargoToDriver *)driver).cargoType,
                                        @"cargo_no": ((CargoToDriver *)driver).cargoNo ?:@""
                                        }];
                }
            }];
        }
    }];
    
    Order *order = self.rowDescriptor.value;
    if (order.orderId) {
        NSDictionary *parameter = @{
                                    @"order_id":order.orderId,
                                    @"cargos":cargos
                                    };
        parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
        [[YGRestClient sharedInstance] postForObjectWithUrl:DispatchUrl form:parameter success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"分配成功"];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

#pragma mark - 属性
- (HMSegmentedControl *)segmentedControl
{
    HMSegmentedControl *segmentedControl = [super segmentedControl];
    segmentedControl.sectionTitles = @[@"订单详情", @"货柜详情"];
    return segmentedControl;
}

-(UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailDS = [[XLFormDataSource alloc] initWithViewController:self tableView:_leftTableView];
        _leftTableView.dataSource = _detailDS;
        _leftTableView.delegate = _detailDS;
        _leftTableView.sectionFooterHeight = 0;
        _leftTableView.tableFooterView = [UIView new];
    }
    return _leftTableView;
}

-(UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _rightTableView.sectionFooterHeight = 0;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.1)];
        _cargosDataSource = [[CargosDataSource alloc] initWithViewController:self tableView:_rightTableView];
        _rightTableView.dataSource = _cargosDataSource;
        _rightTableView.delegate = _cargosDataSource;
        _rightTableView.rowHeight = UITableViewAutomaticDimension;
        _rightTableView.estimatedRowHeight = 44.0;
        [_rightTableView setEditing:YES animated:NO];
        _rightTableView.allowsSelectionDuringEditing = YES;
    }
    return _rightTableView;
}

@end
