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
#import "Order.h"
#import "OrderModel.h"
#import "OrderUtil.h"
#import "LinkUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define RowUI [row.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];\
[row.cellConfig setObject:[UIColor blackColor] forKey:@"textLabel.textColor"];\
row.cellStyle = UITableViewCellStyleValue1;
#define RowPlaceHolderUI(str) [row.cellConfigAtConfigure setObject:str forKey:@"detailTextLabel.text"];

@interface BillApplyViewController ()

@end

@implementation BillApplyViewController

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
        [self initializeForm:company];
    }
    return self;
}

- (void)initializeForm:(Company *)company
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
    }
    row.action.viewControllerClass = [CompanyOptionsViewController class];
    [section addFormRow:row];
    
    //货柜
    section = [XLFormSectionDescriptor formSectionWithTitle:nil sectionOptions:XLFormSectionOptionCanInsert|XLFormSectionOptionCanDelete sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    [section.multivaluedAddButton.cellConfig setObject:@"添加货柜" forKey:@"textLabel.text"];
    section.multivaluedTag = @"cargos";
    [section addFormRow:[self generateCargoRow]];
    
    //自定义Cell
    [self addCustomCell:form];
    
    self.form = form;
}

-(void)addCustomCell:(XLFormDescriptor *)form
{
    //子类实现
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
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
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:YES];
        button.cornerRadius = 4;
        [button setBackgroundColor:ButtonColor];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"提交订单" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitForm:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [bottomView addSubview:saveButton];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.left).offset(10);
        make.right.equalTo(bottomView.right).offset(-10);
        make.top.equalTo(bottomView.top).offset(5);
        make.height.equalTo(@44);
    }];
}

-(CargoFormRowDescriptor *)generateCargoRow
{
    CargoFormRowDescriptor *row = [CargoFormRowDescriptor formRowDescriptorWithTag:nil rowType:kCargoRowDescriptroType];
    [row.cellConfigAtConfigure setObject:@"填入货柜数量" forKey:@"rightTextField.placeholder"];
    NSDictionary *dic = [LinkUtil cargoTypes];
    NSNumber *key = @(1);
    row.value = [Cargo cargoWithType:key name:[dic objectForKey:key] count:@(0)];
    row.action.viewControllerClass = [CargoTypeViewController class];
    return row;
}

//重写获取货柜的cell
-(XLFormRowDescriptor *)formRowFormMultivaluedFormSection:(XLFormSectionDescriptor *)formSection
{
    return [self generateCargoRow];
}

#pragma mark - 事件
-(void)submitForm:(id)sender
{
    NSDictionary *formValues =  [self.form formValues];
    Order *order = (Order *)[OrderUtil modelFromXLFormValue:formValues];
    //同步到服务端
    [OrderUtil syncToServer:order success:^(id responseData) {
        NSString *orderId = responseData[@"order_id"];
        order.orderId = orderId;
        //同步到数据库
        [OrderUtil syncToDataBase:order completion:^{
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
        }];
        [SVProgressHUD showSuccessWithStatus:@"单据保存成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"单据保存失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    CargoFormRowDescriptor *row = [CargoFormRowDescriptor formRowDescriptorWithTag:nil rowType:kCargoRowDescriptroType];
    [row.cellConfigAtConfigure setObject:@"填入货柜号" forKey:@"rightTextField.placeholder"];
    NSDictionary *dic = [LinkUtil cargoTypes];
    NSNumber *key = @(1);
    row.value = [Cargo cargoWithType:key name:[dic objectForKey:key] count:@0];
    row.action.viewControllerClass = [CargoTypeViewController class];
    return row;
}

-(void)addCustomCell:(XLFormDescriptor *)form
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_address" rowType:XLFormRowDescriptorTypeText title:@"提货港口"];
    row.value= @"222";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_time" rowType:XLFormRowDescriptorTypeDate title:@"提货时间"];
    row.value= [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_address" rowType:XLFormRowDescriptorTypeText title:@"送货地址"];
    row.value= @"222";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_time" rowType:XLFormRowDescriptorTypeDate title:@"送货时间"];
    row.value= [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargos_rent_expire" rowType:XLFormRowDescriptorTypeDate title:@"柜租到期日期"];
    row.value= [NSDate date];
    [section addFormRow:row];
    
    //订单信息
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"bill_no" rowType:XLFormRowDescriptorTypeText title:@"提单号"];
    row.value= @"222";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargo_no" rowType:XLFormRowDescriptorTypeText title:@"柜号"];
    row.value= @"222";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargo_company" rowType:XLFormRowDescriptorTypeText title:@"二程公司"];
    row.value= @"222";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_broker" rowType:XLFormRowDescriptorTypeText title:@"报关行联系人"];
    row.value= @"222";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_contact" rowType:XLFormRowDescriptorTypeText title:@"报关行联系人电话"];
    row.value= @"222";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_transfer_port" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    row.value = @(YES);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    row.value= @"222";
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
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

-(void)addCustomCell:(XLFormDescriptor *)form
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_address" rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    row.value= @"333";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_time" rowType:XLFormRowDescriptorTypeDate title:@"到厂时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_address" rowType:XLFormRowDescriptorTypeText title:@"送货地址"];
    row.value= @"333";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_time" rowType:XLFormRowDescriptorTypeDate title:@"送货时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"port" rowType:XLFormRowDescriptorTypeText title:@"提货港口"];
    row.value= @"333";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_in" rowType:XLFormRowDescriptorTypeDate title:@"截关日期"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    //SO图片
    section = [SpecialFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"SO图片"];
    [row.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    row.action.formSelector = NSSelectorFromString(@"addPhotoButtonTapped:");
    section.multivaluedTag = @"soImages";
    [section addFormRow:row];
    
    //公司信息
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ship_company" rowType:XLFormRowDescriptorTypeText title:@"头程公司"];
    row.value= @"333";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ship_name" rowType:XLFormRowDescriptorTypeText title:@"头程船名"];
    row.value= @"333";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ship_schedule_no" rowType:XLFormRowDescriptorTypeText title:@"头程班次"];
    row.value= @"333";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_book_cargo" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否与头程约好柜"];
    row.value = @YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_transfer_port" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    row.value = @YES;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    row.value = @"3333";
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
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

-(void)addCustomCell:(XLFormDescriptor *)form
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_address" rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    row.value = @"444";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"take_time" rowType:XLFormRowDescriptorTypeDate title:@"装货时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_address" rowType:XLFormRowDescriptorTypeText title:@"送货地址"];
    row.value = @"444";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"delivery_time" rowType:XLFormRowDescriptorTypeDate title:@"送货时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_customs_declare" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否需要报关"];
    row.value = @(YES);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"customs_in" rowType:XLFormRowDescriptorTypeDate title:@"报关时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargo_take_time" rowType:XLFormRowDescriptorTypeDate title:@"提货时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"is_transfer_port" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    row.value = @(YES);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
    [section addFormRow:row];
}

@end
