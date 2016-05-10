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
#import "Task.h"
#import "OrderUtil.h"
#import "Driver.h"
#import "TaskCell.h"
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
@property (nonatomic, strong) CargosDataSource *tasksDataSource;
@property (nonatomic, readonly) UIToolbar *toolBar;
@end

@implementation BillDetailViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize leftTableView = _leftTableView;
@synthesize rightTableView = _rightTableView;
@synthesize toolBar = _toolBar;

-(void)dealloc
{
    _detailDS = nil;
    _tasksDataSource = nil;
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
    if ([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin) {
        [self.view addSubview:self.toolBar];
        [self.toolBar makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.bottom);
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
        }];
    }
}

-(void)setupData:(Order *)order
{
    if (_detailDS) {
        [_detailDS setForm:[self createDetailForm:order]];
    }
    if (_tasksDataSource) {
        if([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin){
            [_tasksDataSource setForm:[self createEditTasksForm:order]];
        }else{
            [_tasksDataSource setForm:[self createInfoTasksForm:order]];
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
-(XLFormDescriptor *)createEditTasksForm:(Order *)order
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
-(XLFormDescriptor *)createInfoTasksForm:(Order *)order
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    form.disabled = YES;
    
    for (Task *task in order.tasks) {
        NSString *cargoName = task.cargoType ? [LinkUtil.cargoTypes objectForKey:task.cargoType] :@"";
        section = [XLFormSectionDescriptor formSectionWithTitle:cargoName];
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:TaskInfoDescriporType];
        RowUI
        row.value = task;
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
    NSMutableArray *tasks = [[NSMutableArray alloc]init];
    NSDictionary *formValues = [self.tasksDataSource.form formValues];
    [formValues enumerateKeysAndObjectsUsingBlock:^(NSString *key, id drivers, BOOL * stop) {
        if ([drivers isKindOfClass:[NSArray class]]) {
            [drivers enumerateObjectsUsingBlock:^(id task, NSUInteger idx, BOOL * stop) {
                if ([task isKindOfClass:[Task class]]) {
                    [tasks addObject:@{
                                        @"driver_id":((Task *)task).driverId,
                                        @"cargo_type":((Task *)task).cargoType,
                                        @"cargo_no": ((Task *)task).cargoNo ?:@""
                                        }];
                }
            }];
        }
    }];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"cargos":tasks} options:0 error:NULL];
    NSString *tasksString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    Order *order = self.rowDescriptor.value;
    if (order.orderId) {
        NSDictionary *parameter = @{
                                    @"order_id":order.orderId,
                                    @"dispatch_info":tasksString
                                    };
        parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
        [[YGRestClient sharedInstance] postForObjectWithUrl:DispatchUrl form:parameter success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"分配成功"];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

-(void)acceptAction
{
    [OrderUtil acceptOrder:self.rowDescriptor.value success:^(id responseData) {
        [SVProgressHUD showSuccessWithStatus:@"接单成功"];
    } failure:^(NSError *error) {
        
    }];
}

-(void)confirmAction
{
    [OrderUtil confirmOrder:self.rowDescriptor.value success:^(id responseData) {
        [SVProgressHUD showSuccessWithStatus:@"结单成功"];
    } failure:^(NSError *error) {
        
    }];
}

-(void)rejectAction
{
    [OrderUtil rejectOrder:self.rowDescriptor.value success:^(id responseData) {
        [SVProgressHUD showSuccessWithStatus:@"拒绝成功"];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 属性
- (HMSegmentedControl *)segmentedControl
{
    HMSegmentedControl *segmentedControl = [super segmentedControl];
    segmentedControl.sectionTitles = @[@"订单详情", @"货柜详情"];
    return segmentedControl;
}

-(UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc]init];
        UIBarButtonItem *fixItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixItem.width = 20;
        UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *accpet = [[UIBarButtonItem alloc]initWithTitle:@"接单" style:UIBarButtonItemStyleBordered target:self action:@selector(acceptAction)];
        UIBarButtonItem *confirm = [[UIBarButtonItem alloc]initWithTitle:@"结单" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmAction)];
        UIBarButtonItem *reject = [[UIBarButtonItem alloc]initWithTitle:@"拒绝" style:UIBarButtonItemStyleBordered target:self action:@selector(rejectAction)];
        [_toolBar setItems:@[fixItem, accpet,flex,confirm,flex,reject, fixItem]];
    }
    return _toolBar;
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
        _tasksDataSource = [[CargosDataSource alloc] initWithViewController:self tableView:_rightTableView];
        _rightTableView.dataSource = _tasksDataSource;
        _rightTableView.delegate = _tasksDataSource;
        _rightTableView.rowHeight = UITableViewAutomaticDimension;
        _rightTableView.estimatedRowHeight = 44.0;
        [_rightTableView setEditing:YES animated:NO];
        _rightTableView.allowsSelectionDuringEditing = YES;
    }
    return _rightTableView;
}

@end
