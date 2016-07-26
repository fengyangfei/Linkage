//
//  BillApplyViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/17.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillApplyViewController.h"
#import "CargoFormCell.h"
#import "Cargo.h"
#import "CargoTypeViewController.h"
#import "CargoFormRowDescriptor.h"
#import "TRImagePickerDelegate.h"
#import "BFPaperButton.h"
#import "FormOptionsViewController.h"
#import "Company.h"
#import "SOImage.h"
#import "Order.h"
#import "OrderModel.h"
#import "OrderUtil.h"
#import "LinkUtil.h"
#import "AddressViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
row.cellStyle = UITableViewCellStyleValue1;
#define RowPlaceHolderUI(str) [row.cellConfigAtConfigure setObject:str forKey:@"detailTextLabel.text"];
#define RowAccessoryUI [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
#define RowDateInit [row.cellConfigAtConfigure setObject:[NSDate date] forKey:@"minimumDate"];

@interface BillApplyViewController ()

@end

@implementation BillApplyViewController
@synthesize rowDescriptor = _rowDescriptor;

-(void)dealloc
{
    [TRImagePickerDelegate clearImageIndentifies];
}

- (instancetype)init
{
    return [self initWithCompany:nil];
}

- (instancetype)initWithCompany:(Company *)company
{
    self = [super init];
    if (self) {
        XLFormDescriptor *form = [self initializeForm:company order:nil];
        self.form = form;
    }
    return self;
}

- (XLFormDescriptor *)initializeForm:(Company *)company order:(Order *)order
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"company" rowType:XLFormRowDescriptorTypeButton title:@"承运商"];
    RowUI
    RowPlaceHolderUI(@"请选择承运商")
    if (company) {
        row.value = company;
    }else if (order && order.companyId){
        Company *tmpComp = [[Company alloc]init];
        tmpComp.companyId = order.companyId;
        tmpComp.companyName = order.companyName;
        row.value = tmpComp;
    }
    row.action.viewControllerClass = [CompanyOptionsViewController class];
    [section addFormRow:row];
    
    //货柜
    section = [XLFormSectionDescriptor formSectionWithTitle:nil sectionOptions:XLFormSectionOptionCanInsert|XLFormSectionOptionCanDelete sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    [section.multivaluedAddButton.cellConfig setObject:@"添加货柜" forKey:@"textLabel.text"];
    section.multivaluedTag = @"cargos";
    if (order && order.cargos) {
        for (Cargo *cargo in order.cargos) {
            [section addFormRow:[self generateCargoRowWithType:cargo.cargoType andCount:cargo.cargoCount]];
        }
    }else{
        [section addFormRow:[self generateCargoRowWithType:@(1) andCount:@(0)]];
    }
    
    //自定义Cell
    [self addCustomCell:form order:order];
    
    return form;
}

-(void)addCustomCell:(XLFormDescriptor *)form order:(Order *)order
{
    //子类实现
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom).offset(-54);
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.tableView.bottom);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    BFPaperButton *saveButton = ({
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
        button.cornerRadius = 4;
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:ButtonBgImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:ButtonDisableBgImage forState:UIControlStateDisabled];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"提交订单" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmSubmit:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [bottomView addSubview:saveButton];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.left).offset(10);
        make.right.equalTo(bottomView.right).offset(-10);
        make.top.equalTo(bottomView.top).offset(5);
        make.height.equalTo(@44);
    }];
    
    Order *order = self.rowDescriptor.value;
    if (order && order.orderId) {
        [self loadDataFromServer:order];
    }
}

//从服务端加载详情
-(void)loadDataFromServer:(Order *)order
{
    WeakSelf
    [SVProgressHUD show];
    [OrderUtil queryModelFromServer:order completion:^(Order *result) {
        XLFormDescriptor *form = [weakSelf initializeForm:nil order:result];
        [weakSelf setForm:form];
        [SVProgressHUD dismiss];
        [OrderUtil syncToDataBase:result completion:nil];
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

-(CargoFormRowDescriptor *)generateCargoRowWithType:(NSNumber *)typeKey andCount:(NSNumber *)count
{
    CargoFormRowDescriptor *row = [CargoFormRowDescriptor formRowDescriptorWithTag:nil rowType:kCargoRowDescriptroType];
    [row.cellConfigAtConfigure setObject:@"填入货柜数量" forKey:@"rightTextField.placeholder"];
    NSDictionary *dic = [LinkUtil cargoTypes];
    row.value = [Cargo cargoWithType:typeKey name:[dic objectForKey:typeKey] count:count];
    row.action.viewControllerClass = [CargoTypeViewController class];
    return row;
}

//重写获取货柜的cell
-(XLFormRowDescriptor *)formRowFormMultivaluedFormSection:(XLFormSectionDescriptor *)formSection
{
    return [self generateCargoRowWithType:@(1) andCount:@(0)];
}

#pragma mark - 事件
-(void)confirmSubmit:(UIButton *)sender
{
    NSArray *errors = [self formValidationErrors];
    if (errors && errors.count > 0) {
        NSError *error = [errors firstObject];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    WeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请确认是否提交订单？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf submitForm:sender];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

-(void)submitForm:(UIButton *)sender
{
    sender.enabled = NO;
    WeakSelf
    NSMutableDictionary *formValues =  [[self.form formValues] mutableCopy];
    Order *existOrder = self.rowDescriptor.value;
    if (existOrder && existOrder.orderId) {
        formValues[@"order_id"] = existOrder.orderId;
    }
    if ([self isKindOfClass:[BillExportApplyViewController class]]) {
        formValues[@"type"] = @(OrderTypeExport);
    }else if([self isKindOfClass:[BillImportApplyViewController class]]){
        formValues[@"type"] = @(OrderTypeImport);
    }else if ([self isKindOfClass:[BillSelfApplyViewController class]]){
        formValues[@"type"] = @(OrderTypeSelf);
    }
    Order *order = (Order *)[OrderUtil modelFromXLFormValue:[formValues copy]];
    //同步到服务端
    [OrderUtil syncToServer:order success:^(id responseData) {
        sender.enabled = YES;
        NSString *orderId = responseData[@"order_id"];
        order.orderId = orderId;
        //同步到数据库
        [OrderUtil syncToDataBase:order completion:^{
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
        }];
        [SVProgressHUD showSuccessWithStatus:@"单据保存成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        sender.enabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"单据保存失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 方法(添加地址)
-(void)addAddressRow:(XLFormRowDescriptor *)row
{
    AddressType type = AddressTypeTake;
    if ([row.tag isEqualToString:@"take_address"]) {
        type = AddressTypeTake;
    }else if ([row.tag isEqualToString:@"delivery_address"]){
        type = AddressTypeDelivery;
    }
    AddressViewController *controller = [[AddressViewController alloc]initWithControllerType:ControllerTypeQuery addressType:type];
    controller.rowDescriptor = row;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

#pragma mark - 进口订单
@implementation BillImportApplyViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"进口订单";
}

-(CargoFormRowDescriptor *)generateCargoRow
{
    CargoFormRowDescriptor *row = [CargoFormRowDescriptor formRowDescriptorWithTag:nil rowType:kImportCargoRowDescriptroType];
    [row.cellConfigAtConfigure setObject:@"填入货柜号" forKey:@"rightTextField.placeholder"];
    NSDictionary *dic = [LinkUtil cargoTypes];
    NSNumber *key = @(0);
    row.value = [Cargo cargoWithType:key name:[dic objectForKey:key]];
    row.action.viewControllerClass = [CargoTypeViewController class];
    return row;
}

-(void)addCustomCell:(XLFormDescriptor *)form order:(Order *)order
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_address_option" rowType:XLFormRowDescriptorTypeSelectorPush title:@"进口港口"];
    row.noValueDisplayText = @"请选择进口港口";
    row.required = YES;
    if (order && order.takeAddress) {
        row.value = [XLFormOptionsObject formOptionsObjectWithValue:order.takeAddress displayText:order.takeAddress];
    }
    row.selectorOptions = [LinkUtil portOptions];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_time" rowType:XLFormRowDescriptorTypeDate title:@"提货时间"];
    RowDateInit
    if (order && order.takeTime) {
        row.value = order.takeTime;
    }else{
        row.value = [NSDate date];
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_address" rowType:XLFormRowDescriptorTypeButton title:@"送货地址"];
    RowUI
    RowAccessoryUI
    RowPlaceHolderUI(@"请选择送货地址")
    if (order && order.deliveryAddress) {
        row.value = order.deliveryAddress;
    }
    row.required = YES;
    row.action.formSelector = @selector(addAddressRow:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_time" rowType:XLFormRowDescriptorTypeDate title:@"送货时间"];
    RowDateInit
    if (order && order.deliverTime) {
        row.value = order.deliverTime;
    }else{
        row.value= [NSDate date];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargos_rent_expire" rowType:XLFormRowDescriptorTypeDate title:@"柜租到期日期"];
    RowDateInit
    if (order && order.cargosRentExpire) {
        row.value = order.cargosRentExpire;
    }else{
        row.value= [NSDate date];
    }
    [section addFormRow:row];
    
    //订单信息
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"bill_no" rowType:XLFormRowDescriptorTypeText title:@"提单号"];
    if (order && [order isKindOfClass:[ImportOrder class]] && ((ImportOrder *)order).billNo) {
        row.value = ((ImportOrder *)order).billNo;
    }
    row.required = YES;
    [section addFormRow:row];
    
    /*
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargo_no" rowType:XLFormRowDescriptorTypeText title:@"柜号"];
    if (order && ((ImportOrder *)order).cargoNo) {
        row.value = ((ImportOrder *)order).cargoNo;
    }
    row.required = YES;
    [section addFormRow:row];
     */
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargo_company" rowType:XLFormRowDescriptorTypeText title:@"二程公司"];
    if (order && ((ImportOrder *)order).cargoCompany) {
        row.value = ((ImportOrder *)order).cargoCompany;
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_broker" rowType:XLFormRowDescriptorTypeText title:@"报关行联系人"];
    if (order && ((ImportOrder *)order).customsBroker) {
        row.value = ((ImportOrder *)order).customsBroker;
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_contact" rowType:XLFormRowDescriptorTypeText title:@"报关行联系人电话"];
    if (order && ((ImportOrder *)order).customsHouseContact) {
        row.value = ((ImportOrder *)order).customsHouseContact;
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_transfer_port" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    if (order && ((ImportOrder *)order).isTransferPort) {
        row.value = @(((ImportOrder *)order).isTransferPort);
    }else{
        row.value = @(YES);
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
    if (order && order.memo) {
        row.value = order.memo;
    }
    [section addFormRow:row];
}

@end

#pragma mark - 出口订单
#import "SOImageFormCell.h"
#import "XLFormViewController+ImagePicker.h"
@implementation BillExportApplyViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"出口订单";
}

-(void)addCustomCell:(XLFormDescriptor *)form order:(Order *)order
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_address" rowType:XLFormRowDescriptorTypeButton title:@"装货地址"];
    RowUI
    RowAccessoryUI
    RowPlaceHolderUI(@"请选择装货地址")
    if (order && order.takeAddress) {
        row.value = order.takeAddress;
    }
    row.required = YES;
    row.action.formSelector = @selector(addAddressRow:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_time" rowType:XLFormRowDescriptorTypeDate title:@"到厂时间"];
    RowDateInit
    if (order && order.takeTime) {
        row.value = order.takeTime;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_time" rowType:XLFormRowDescriptorTypeDate title:@"送货时间"];
    RowDateInit
    if (order && order.deliverTime) {
        row.value = order.deliverTime;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"port_option" rowType:XLFormRowDescriptorTypeSelectorPush title:@"出口港口"];
    row.noValueDisplayText = @"请选择出口港口";
    if (order && ((ExportOrder *)order).port) {
        NSString *p = ((ExportOrder *)order).port;
        row.value = [XLFormOptionsObject formOptionsObjectWithValue:p displayText:p];
    }
    row.required = YES;
    row.selectorOptions = [LinkUtil portOptions];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_in" rowType:XLFormRowDescriptorTypeDate title:@"截关日期"];
    RowDateInit
    if (order && ((ExportOrder *)order).customsIn) {
        row.value = ((ExportOrder *)order).customsIn;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];
    
    //SO图片
    section = [SpecialFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"SO图片"];
    [row.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    row.action.formSelector = NSSelectorFromString(@"addSoImage:");
    section.multivaluedTag = @"soImages";
    [section addFormRow:row];
    
    if (order && ((ExportOrder *)order).soImageUrl) {
        for (NSString *imageUrl in [((ExportOrder *)order).soImageUrl componentsSeparatedByString:@";"]) {
            if(StringIsNotEmpty(imageUrl)){
                SOImage *model = [[SOImage alloc]init];
                model.imageUrl = imageUrl;
                
                row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:SOImageRowDescriporType];
                row.value = model;
                [section addFormRow:row];
            }
        }
    }
    
    //公司信息
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ship_company" rowType:XLFormRowDescriptorTypeText title:@"头程公司"];
    if (order && ((ExportOrder *)order).shipCompany) {
        row.value = ((ExportOrder *)order).shipCompany;
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ship_name" rowType:XLFormRowDescriptorTypeText title:@"头程船名"];
    if (order && ((ExportOrder *)order).shipName) {
        row.value = ((ExportOrder *)order).shipName;
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ship_schedule_no" rowType:XLFormRowDescriptorTypeText title:@"头程班次"];
    if (order && ((ExportOrder *)order).shipScheduleNo) {
        row.value = ((ExportOrder *)order).shipScheduleNo;
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_book_cargo" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否与头程约好柜"];
    if (order && ((ExportOrder *)order).isBookCargo) {
        row.value = @(((ExportOrder *)order).isBookCargo);
    }else{
        row.value = @YES;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_transfer_port" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    if (order && ((ExportOrder *)order).isTransferPort) {
        row.value = @(((ExportOrder *)order).isTransferPort);
    }else{
        row.value = @YES;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
    if (order && ((ExportOrder *)order).memo) {
        row.value = ((ExportOrder *)order).memo;
    }
    [section addFormRow:row];
}

#pragma mark - 重写tableviewDataSource方法
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self imageWithTableView:tableView editingStyleForRowAtIndexPath:indexPath];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self imageWithTableView:tableView editingStyleForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self imageWithTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

@end

#pragma mark - 自备柜配送订单

@implementation BillSelfApplyViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"自备柜配送";
}

-(void)addCustomCell:(XLFormDescriptor *)form order:(Order *)order
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_address" rowType:XLFormRowDescriptorTypeButton title:@"装货地址"];
    RowUI
    RowAccessoryUI
    RowPlaceHolderUI(@"请选择装货地址")
    if (order && order.takeAddress) {
        row.value = order.takeAddress;
    }
    row.required = YES;
    row.action.formSelector = @selector(addAddressRow:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_time" rowType:XLFormRowDescriptorTypeDate title:@"装货时间"];
    RowDateInit
    if (order && order.takeTime) {
        row.value = order.takeTime;
    }else{
        row.value = [NSDate date];
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_address" rowType:XLFormRowDescriptorTypeButton title:@"送货地址"];
    RowUI
    RowAccessoryUI
    RowPlaceHolderUI(@"请选择送货地址")
    if (order && order.deliveryAddress) {
        row.value = order.deliveryAddress;
    }
    row.required = YES;
    row.action.formSelector = @selector(addAddressRow:);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_time" rowType:XLFormRowDescriptorTypeDate title:@"送货时间"];
    RowDateInit
    if (order && order.deliverTime) {
        row.value = order.deliverTime;
    }else{
        row.value = [NSDate date];
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_customs_declare" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否需要报关"];
    if (order && ((SelfOrder *)order).isCustomsDeclare) {
        row.value = @(((SelfOrder *)order).isCustomsDeclare);
    }else{
        row.value = @(YES);
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_in" rowType:XLFormRowDescriptorTypeDate title:@"报关时间"];
    RowDateInit
    if (order && ((SelfOrder *)order).customsIn) {
        row.value = ((SelfOrder *)order).customsIn;
    }else{
        row.value = [NSDate date];
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargo_take_time" rowType:XLFormRowDescriptorTypeDate title:@"提货时间"];
    RowDateInit
    if (order && ((SelfOrder *)order).cargoTakeTime) {
        row.value = ((SelfOrder *)order).cargoTakeTime;
    }else{
        row.value = [NSDate date];
    }
    row.required = YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_transfer_port" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    if (order && order.isTransferPort) {
        row.value = @(order.isTransferPort);
    }else{
        row.value = @(YES);
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
    if (order && order.memo) {
        row.value = order.memo;
    }
    [section addFormRow:row];
}
@end
