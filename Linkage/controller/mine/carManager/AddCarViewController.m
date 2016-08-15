//
//  AddCarViewController.m
//  Linkage
//
//  Created by lihaijian on 16/4/18.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddCarViewController.h"
#import "Car.h"
#import "CarModel.h"
#import "CarUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation AddCarViewController
@synthesize rowDescriptor = _rowDescriptor;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm:nil];
    }
    return self;
}

- (void)initializeForm:(Car *)car
{
    XLFormDescriptor *form = [self createForm:car];
    self.form = form;
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self initializeForm:rowDescriptor.value];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 18)];
}

-(XLFormDescriptor *)createForm:(Car *)car
{
    WeakSelf
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"车辆信息"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"license" rowType:XLFormRowDescriptorTypeText title:@"车牌号码"];
    row.value = car?car.license:@"";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"engine_no" rowType:XLFormRowDescriptorTypeText title:@"发动机号码"];
    row.value = car?car.engineNo:@"";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"frame_no" rowType:XLFormRowDescriptorTypeText title:@"车架号"];
    row.value = car?car.frameNo :@"";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"apply_date" rowType:XLFormRowDescriptorTypeDate title:@"上牌日期"];
    if(car && car.applyDate){
        row.value = car.applyDate;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"examine_data" rowType:XLFormRowDescriptorTypeDate title:@"年审日期"];
    if(car && car.examineData){
        row.value = car.examineData;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"maintain_data" rowType:XLFormRowDescriptorTypeDate title:@"车辆营运证年审月份"];
    if(car && car.maintainData){
        row.value = car.maintainData;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"traffic_insure_data" rowType:XLFormRowDescriptorTypeDate title:@"交强险日期"];
    if(car && car.trafficInsureData){
        row.value = car.trafficInsureData;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"business_insure_data" rowType:XLFormRowDescriptorTypeDate title:@"商业险日期"];
    if(car && car.businessInsureData){
        row.value = car.businessInsureData;
    }else{
        row.value = [NSDate date];
    }
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"insure_company" rowType:XLFormRowDescriptorTypeText title:@"保险公司名称"];
    row.value = car?car.insureCompany :@"";
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"memo" rowType:XLFormRowDescriptorTypeTextView title:@"备注信息"];
    row.value = car?car.memo :@"";
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    NSString *title;
    if (car && StringIsNotEmpty(car.carId)) {
        title = @"修改";
    }else{
        title = @"保存";
    }
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:title];
    row.action.formBlock  = ^(XLFormRowDescriptor * sender){
        [weakSelf submitForm:sender];
    };
    [section addFormRow:row];
    
    return form;
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
    Car *model = (Car *)[CarUtil modelFromXLFormValue:formValues];
    if (_rowDescriptor.value) {
        model.carId = ((Car *)_rowDescriptor.value).carId;
    }
    //同步到服务端
    [SVProgressHUD show];
    [CarUtil syncToServer:model success:^(id responseData) {
        NSString *carId = responseData[@"car_id"];
        if (carId) {
            model.carId = carId;
            //同步到数据库
            [CarUtil syncToDataBase:model completion:^{
                [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                    [SVProgressHUD dismiss];
                }];
            }];
        }
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}

@end
