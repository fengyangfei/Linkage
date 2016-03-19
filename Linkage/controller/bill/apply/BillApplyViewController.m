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

@interface BillApplyViewController ()

@end

@implementation BillApplyViewController

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
    WeakSelf
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
    
    //日期
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"address" rowType:XLFormRowDescriptorTypeText title:@"装货地址"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"XLFormRowDescriptorTypeDateInline" rowType:XLFormRowDescriptorTypeText title:@"到达时间"];
    [section addFormRow:row];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"arrivatTime" rowType:XLFormRowDescriptorTypeDateInline title:@"到达时间"];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"arrivate" rowType:XLFormRowDescriptorTypeText title:@"提货港口"];
    
    //so图片
    [self addSOImageCell:form];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"提交订单"];
    row.action.formBlock = ^(XLFormRowDescriptor *sender){
        [weakSelf submitForm];
    };
    [section addFormRow:row];
    self.form = form;
}

-(void)addSOImageCell:(XLFormDescriptor *)form
{
    //子类实现
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
-(void)submitForm
{
    NSDictionary *formValues = [self formValues];
    NSLog(@"formValues %@", formValues);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

#import "SOImageFormCell.h"
#import "SOImageModel.h"
#import "UIViewController+TRImagePicker.h"
#import "SpecialFormSectionDescriptor.h"
@implementation BillImportApplyViewController

-(void)addSOImageCell:(XLFormDescriptor *)form
{
    SpecialFormSectionDescriptor *section = [SpecialFormSectionDescriptor formSection];
    [form addFormSection:section];
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"SO图片"];
    [row.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
    row.action.formSelector = NSSelectorFromString(@"addPhotoButtonTapped:");
    [section addFormRow:row];
}

-(void)addPhotoButtonTapped:(XLFormRowDescriptor *)formRow
{
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
            [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }
    }else{
        [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

@end

@implementation BillExportApplyViewController


@end
