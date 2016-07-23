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
#import "CommentViewController.h"
#import "ImageInfoCell.h"
#import "BFPaperButton.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
@interface BillDetailViewController()<XLFormRowDescriptorViewController>
@property (nonatomic, strong) XLFormDataSource *detailDS;
@property (nonatomic, strong) CargosDataSource *tasksDataSource;
@property (nonatomic, readonly) UIToolbar *toolBar;
@property (nonatomic, readonly) UIBarButtonItem *acceptItem;
@property (nonatomic, readonly) UIBarButtonItem *confirmItem;
@property (nonatomic, readonly) UIBarButtonItem *rejectItem;
@property (nonatomic, readonly) UIBarButtonItem *flexibleItem;
@property (nonatomic, readonly) UIBarButtonItem *fixedItem;
@end

@implementation BillDetailViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize leftTableView = _leftTableView;
@synthesize rightTableView = _rightTableView;
@synthesize toolBar = _toolBar;
@synthesize acceptItem = _acceptItem;
@synthesize confirmItem = _confirmItem;
@synthesize rejectItem = _rejectItem;
@synthesize flexibleItem = _flexibleItem;
@synthesize fixedItem = _fixedItem;

-(void)dealloc
{
    _detailDS = nil;
    _tasksDataSource = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    Order *order = self.rowDescriptor.value;
    [self setupData:order];
    [self loadDataFromServer:order];
    [self bindViewModel:order];
}

//从服务端加载详情
-(void)loadDataFromServer:(Order *)order
{
    WeakSelf
    if (order.orderId) {
        [SVProgressHUD show];
        [OrderUtil queryModelFromServer:order completion:^(Order *result) {
            [OrderUtil syncToDataBase:result completion:nil];
            [weakSelf setupData:result];
            [SVProgressHUD dismiss];
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

-(void)bindViewModel:(Order *)order
{
    @weakify(self)
    RACSignal *signal = RACObserve(order, status);
    [signal subscribeNext:^(NSNumber *x) {
        @strongify(self)
        [self updateUIWhenOrderState:x];
    }];
}

//订单状态改变UI更新
-(void)updateUIWhenOrderState:(NSNumber *)x
{
    if([x integerValue] == OrderStatusCompletion){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(gotoCommentViewController)];
    }
    if (([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin || [LoginUser shareInstance].ctype == UserTypeSubCompanyUser) && ([x integerValue] == OrderStatusPending || [x integerValue] == OrderStatusExecuting)) {
        [self.view addSubview:self.toolBar];
        [self.toolBar makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.bottom);
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
        }];
        
        if ([x integerValue] == OrderStatusPending) {
            [self.toolBar setItems:@[self.acceptItem, self.rejectItem]];
        }else if ([x integerValue] == OrderStatusExecuting){
            [self.toolBar setItems:@[self.confirmItem]];
        }
    }else{
        if (_toolBar) {
            [_toolBar removeFromSuperview];
        }
    }
    Order *order = self.rowDescriptor.value;
    [self loadDataFromServer:order];
}

//设置表格的数据源
-(void)setupData:(Order *)order
{
    if (_detailDS) {
        [_detailDS setForm:[self createDetailForm:order]];
    }
    if (_tasksDataSource) {
        //承运商可分配任务，厂商只能查看任务
        if([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin){
            if (order.tasks && order.tasks.count > 0) {
                [_tasksDataSource setForm:[self createInfoTasksForm:order]];
            }else{
                if(order.status != OrderStatusCompletion && order.status != OrderStatusDenied){
                    [_tasksDataSource setForm:[self createEditTasksForm:order]];
                }
            }
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
        ExportOrder *exportOrder = (ExportOrder *)order;
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"头程公司"];
        row.value = order? exportOrder.shipCompany :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"头程船名"];
        row.value = order? exportOrder.shipName :@"";
        [section addFormRow:row];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:@"是否约好"];
        if (order && exportOrder.isBookCargo) {
            row.value = @"是";
        }else{
            row.value = @"否";
        }
        [section addFormRow:row];
        
        if (order && exportOrder.soImageUrl) {
            for (NSString *imageUrl in [exportOrder.soImageUrl componentsSeparatedByString:@";"]) {
                if(StringIsNotEmpty(imageUrl)){
                    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:ImageInfoDescriporTypeCell title:@"SO图片"];
                    row.value = imageUrl;
                    [section addFormRow:row];
                }
            }
        }
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
    if (order && order.isTransferPort) {
        row.value = @"是";
    }else{
        row.value = @"否";
    }
    [section addFormRow:row];
    
    return form;
}

//分配任务的form
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

//查看任务详情的form
-(XLFormDescriptor *)createInfoTasksForm:(Order *)order
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    form = [XLFormDescriptor formDescriptorWithTitle:@""];
    form.disabled = YES;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    //承运商在订单未完成的前提下可修改任务状态
    BOOL allowEdit = NO;
    if ([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin && order.status != OrderStatusCompletion) {
        allowEdit = YES;
    }
    NSString *rowType = allowEdit? TaskEditDescriporType:TaskInfoDescriporType;
    for (Task *task in order.tasks) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:rowType];
        RowUI
        row.value = task;
        [section addFormRow:row];
    }
    return form;
}

#pragma mark - 事件处理
//跳转到评论
-(void)gotoCommentViewController
{
    CommentViewController *viewController = [[CommentViewController alloc]init];
    viewController.rowDescriptor = self.rowDescriptor;
    [self.navigationController pushViewController:viewController animated:YES];
}

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

//接单
-(void)confirmAccept
{
    WeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否接单？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf acceptAction];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

-(void)acceptAction
{
    Order *order = (Order *)self.rowDescriptor.value;
    __weak Order *weakOrder = order;
    [OrderUtil acceptOrder:order success:^(id responseData) {
        [SVProgressHUD showSuccessWithStatus:@"接单成功"];
        weakOrder.status = OrderStatusExecuting;
        [OrderUtil syncToDataBase:weakOrder completion:nil];
    } failure:^(NSError *error) {
        
    }];
}

//结单
-(void)confirmCompletion
{
    WeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否完成订单？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf confirmAction];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

//结单
-(void)confirmAction
{
    Order *order = (Order *)self.rowDescriptor.value;
    __weak Order *weakOrder = order;
    [OrderUtil confirmOrder:order success:^(id responseData) {
        [SVProgressHUD showSuccessWithStatus:@"结单成功"];
        weakOrder.status = OrderStatusCompletion;
        [OrderUtil syncToDataBase:weakOrder completion:nil];
    } failure:^(NSError *error) {
        
    }];
}

//拒绝
-(void)confirmReject
{
    WeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否拒绝？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf rejectAction];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

//拒绝
-(void)rejectAction
{
    Order *order = (Order *)self.rowDescriptor.value;
    __weak Order *weakOrder = order;
    [OrderUtil rejectOrder:order success:^(id responseData) {
        [SVProgressHUD showSuccessWithStatus:@"拒绝成功"];
        weakOrder.status = OrderStatusDenied;
        [OrderUtil syncToDataBase:weakOrder completion:nil];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 属性
- (HMSegmentedControl *)segmentedControl
{
    HMSegmentedControl *segmentedControl = [super segmentedControl];
    segmentedControl.sectionTitles = @[@"订单详情", @"任务详情"];
    return segmentedControl;
}

-(UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc]init];
    }
    return _toolBar;
}

-(UIBarButtonItem *)acceptItem
{
    if (!_acceptItem) {
        //_acceptItem = [[UIBarButtonItem alloc]initWithTitle:@"接单" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmAccept)];
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
        button.cornerRadius = 4;
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:ButtonDisableBgImage forState:UIControlStateDisabled];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"接单" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmAccept) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, IPHONE_WIDTH / 2 - 22 , 40);
        _acceptItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _acceptItem;
}

-(UIBarButtonItem *)confirmItem
{
    if (!_confirmItem) {
        //_confirmItem = [[UIBarButtonItem alloc]initWithTitle:@"结单" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmCompletion)];
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
        button.cornerRadius = 4;
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:ButtonDisableBgImage forState:UIControlStateDisabled];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"完成订单" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, IPHONE_WIDTH - 34 , 40);
        [button addTarget:self action:@selector(confirmCompletion) forControlEvents:UIControlEventTouchUpInside];
        _confirmItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    }
    return _confirmItem;
}

-(UIBarButtonItem *)rejectItem
{
    if (!_rejectItem) {
        //_rejectItem = [[UIBarButtonItem alloc]initWithTitle:@"拒绝" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmReject)];
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
        button.cornerRadius = 4;
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:ButtonDisableBgImage forState:UIControlStateDisabled];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"拒绝" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, IPHONE_WIDTH / 2 - 22, 40);
        [button addTarget:self action:@selector(confirmReject) forControlEvents:UIControlEventTouchUpInside];
        _rejectItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    return _rejectItem;
}

-(UIBarButtonItem *)fixedItem
{
    if (!_fixedItem) {
        _fixedItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _fixedItem.width = 20;
    }
    return _fixedItem;
}

-(UIBarButtonItem *)flexibleItem
{
    if (!_flexibleItem) {
        _flexibleItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _flexibleItem;
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
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
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
        _rightTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    return _rightTableView;
}

@end
