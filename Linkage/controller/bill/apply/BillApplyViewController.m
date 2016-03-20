//
//  BillApplyViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/17.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillApplyViewController.h"
#import "CargoFormCell.h"
#import "CargoModel.h"
#import "CargoTypeViewController.h"
#import "CargoFormRowDescriptor.h"
#import "TRImagePickerDelegate.h"
#import "BFPaperButton.h"

@interface BillApplyViewController ()

@end

@implementation BillApplyViewController

-(void)dealloc
{
    [TRImagePickerDelegate clearImageIndentifies];
}

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
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"billNum" rowType:XLFormRowDescriptorTypeText title:@"订单号"];
    row.required = YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"subCompany" rowType:XLFormRowDescriptorTypeText title:@"承运商"];
    row.required = YES;
    [section addFormRow:row];
    
    //货柜
    section = [XLFormSectionDescriptor formSectionWithTitle:nil sectionOptions:XLFormSectionOptionCanInsert|XLFormSectionOptionCanDelete sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    [section.multivaluedAddButton.cellConfig setObject:@"添加货柜" forKey:@"textLabel.text"];
    section.multivaluedTag = @"cargo";
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
    self.tableView.sectionHeaderHeight = 0.0f;
    self.tableView.sectionFooterHeight = 10.0f;
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
    NSDictionary *dic = [CargoTypeViewController cargoTypes];
    NSNumber *key = @(1);
    row.value = [CargoModel cargoModelWithValue:key displayText:[dic objectForKey:key] cargoCount:nil];
    row.action.viewControllerClass = [CargoTypeViewController class];
    [[row cellConfig] setObject:@"输入货柜数量" forKey:@"rightTextField.placeholder"];
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
    NSDictionary *formValues = [self formValues];
    NSLog(@"formValues %@", formValues);
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

-(void)addCustomCell:(XLFormDescriptor *)form
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"packingAddress" rowType:XLFormRowDescriptorTypeText title:@"柜租到期日期"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"arrivalDate" rowType:XLFormRowDescriptorTypeText title:@"提柜港口"];
    row.value = [NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"deliveryDate" rowType:XLFormRowDescriptorTypeDateInline title:@"送货地址"];
    row.value = [NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"deliveryPort" rowType:XLFormRowDescriptorTypeDateInline title:@"到厂时间"];
    [section addFormRow:row];
    
    //订单信息
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"headerCompany" rowType:XLFormRowDescriptorTypeText title:@"提单号"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargoNum" rowType:XLFormRowDescriptorTypeText title:@"柜号"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"headerGrades" rowType:XLFormRowDescriptorTypeText title:@"二程公司"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"contact" rowType:XLFormRowDescriptorTypeText title:@"报关行联系人"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phone" rowType:XLFormRowDescriptorTypeText title:@"报关行联系人电话"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"isTransit" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"note" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
    [section addFormRow:row];
}

@end

#pragma mark - 出口订单
#import "SOImageFormCell.h"
#import "SOImageModel.h"
#import "UIViewController+TRImagePicker.h"
#import "SpecialFormSectionDescriptor.h"
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
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"packingAddress" rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"arrivalDate" rowType:XLFormRowDescriptorTypeDateInline title:@"到厂时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"deliveryDate" rowType:XLFormRowDescriptorTypeDateInline title:@"到达时间"];
    row.value = [NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"deliveryPort" rowType:XLFormRowDescriptorTypeText title:@"提货港口"];
    [section addFormRow:row];
    
    //SO图片
    section = [SpecialFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"SO图片"];
    [row.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    row.action.formSelector = NSSelectorFromString(@"addPhotoButtonTapped:");
    section.multivaluedTag = @"soImage";
    [section addFormRow:row];
    
    //公司信息
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"headerCompany" rowType:XLFormRowDescriptorTypeText title:@"头程公司"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"headerName" rowType:XLFormRowDescriptorTypeText title:@"头程船名"];
    row.value = [NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"headerGrades" rowType:XLFormRowDescriptorTypeText title:@"头程班次"];
    row.value = [NSDate date];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"isDating" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否与头程约好柜"];
    row.value = @YES;
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"isTransit" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"isTransit" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"note" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
    [section addFormRow:row];
}

-(void)addPhotoButtonTapped:(XLFormRowDescriptor *)formRow
{
    [self deselectFormRow:formRow];
    [self addMultiplePhoto:^(UIImage *image, NSString *fileName) {
        //添加到当前列的value里面
        SOImageModel *model = [[SOImageModel alloc]init];
        model.photoName = fileName;
        model.createDate = [NSDate date];
        model.photo = image;
        
        //添加新的一列
        XLFormRowDescriptor *newRow = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:SOImageRowDescriporType];
        newRow.value = model;
        XLFormSectionDescriptor *currentFormSection = formRow.sectionDescriptor;
        [currentFormSection addFormRow:newRow afterRow:formRow];
    }];
}

#pragma mark - 重写tableviewDataSource方法
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *row = [self.form formRowAtIndex:indexPath];
    if ([row.sectionDescriptor isKindOfClass:[SpecialFormSectionDescriptor class]]) {
        return YES;
    }else{
        return [super tableView:tableView canEditRowAtIndexPath:indexPath];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *row = [self.form formRowAtIndex:indexPath];
    if ([row.sectionDescriptor isKindOfClass:[SpecialFormSectionDescriptor class]]) {
        if (indexPath.row == 0){
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }else{
        return [super tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *row = [self.form formRowAtIndex:indexPath];
    if ([row.sectionDescriptor isKindOfClass:[SpecialFormSectionDescriptor class]]) {
        if (editingStyle == UITableViewCellEditingStyleInsert){
            [self addPhotoButtonTapped:row];
        }else if(editingStyle == UITableViewCellEditingStyleDelete){
            if ([row.value isKindOfClass:[SOImageModel class]]) {
                [TRImagePickerDelegate removeImageIndentifyByKey:((SOImageModel *)row.value).photoName];
            }
            [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }
    }else{
        [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

@end

#pragma mark - 自备柜配送订单

@implementation BillCustomApplyViewController

-(void)addCustomCell:(XLFormDescriptor *)form
{
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    //日期与地点
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"packingAddress" rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"arrivalDate" rowType:XLFormRowDescriptorTypeDateInline title:@"装货时间"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"deliveryDate" rowType:XLFormRowDescriptorTypeText title:@"送货地址"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"deliveryPort" rowType:XLFormRowDescriptorTypeDateInline title:@"送货时间"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"headerCompany" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否需要报关"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"cargoNum" rowType:XLFormRowDescriptorTypeDateInline title:@"报关时间"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"headerGrades" rowType:XLFormRowDescriptorTypeDateInline title:@"提货时间"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"isTransit" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"是否转关"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"note" rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    [row.cellConfigAtConfigure setObject:@"请填写备注" forKey:@"textView.placeholder"];
    [section addFormRow:row];
}

@end
