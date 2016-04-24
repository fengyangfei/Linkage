//
//  BillTableViewCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/15.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillTableViewCell.h"
#import "OrderModel.h"
#import "Order.h"

NSString *const TodoBillDescriporType = @"TodoBillRowType";
NSString *const DoneBillDescriporType = @"DoneBillRowType";

@implementation BillTableViewCell

#pragma mark - 生命周期
-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
}

-(void)update
{
    [super update];
    OrderModel *order = self.rowDescriptor.value;
    self.billNumLable.text = order.companyId;
    self.detailLable.text = order.memo;
    self.timeLable.text = order.takeAddress;
    self.ratingLable.text = order.deliveryAddress;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 80;
}

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController *)controller
{
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
    else{
        UIViewController * controllerToPresent = [[self.rowDescriptor.action.viewControllerClass alloc] init];
        if (controllerToPresent){
            if ([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
                ((UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent).rowDescriptor = self.rowDescriptor;
            }
            if (controller.navigationController == nil || [controllerToPresent isKindOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == XLFormPresentationModePresent){
                [controller presentViewController:controllerToPresent animated:YES completion:nil];
            }
            else{
                controllerToPresent.hidesBottomBarWhenPushed = YES;
                [controller.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
        
    }
}

#pragma mark - UI
-(void)setupUI
{
    [self.contentView addSubview:self.billNumLable];
    [self.billNumLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.centerY);
    }];
    
    [self.contentView addSubview:self.timeLable];
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-8);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.centerY);
    }];
    
    [self.contentView addSubview:self.detailLable];
    [self.detailLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.top.equalTo(self.contentView.centerY);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.contentView addSubview:self.ratingLable];
    [self.ratingLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-8);
        make.top.equalTo(self.contentView.centerY);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

-(UILabel *)billNumLable
{
    if (!_billNumLable) {
        _billNumLable = [UILabel new];
    }
    return _billNumLable;
}

-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:12];
    }
    return _timeLable;
}

-(UILabel *)detailLable
{
    if (!_detailLable) {
        _detailLable = [UILabel new];
        _detailLable.font = [UIFont systemFontOfSize:10];
    }
    return _detailLable;
}

-(UILabel *)ratingLable
{
    if (!_ratingLable) {
        _ratingLable = [UILabel new];
        _ratingLable.font = [UIFont systemFontOfSize:10];
        _ratingLable.textColor = [UIColor grayColor];
    }
    return _ratingLable;
}

@end

@implementation CompanyTableViewCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TodoBillDescriporType];
}

@end

@implementation SubCompanyTableViewCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:DoneBillDescriporType];
}

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController *)controller
{
    
}

@end
