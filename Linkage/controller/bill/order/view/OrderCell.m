//
//  OrderCell.m
//  Linkage
//
//  Created by Mac mini on 16/5/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "OrderCell.h"
#import "Order.h"
#import "NSString+Hint.h"
#import "LinkUtil.h"

NSString *const PendingOrderDescriporType = @"PendingOrderRowType";
NSString *const CompletionOrderDescriporType = @"CompletionOrderRowType";

@interface OrderCell()
@property (nonatomic, readonly) UILabel *billNumLable;
@property (nonatomic, readonly) UILabel *timeLable;
@property (nonatomic, readonly) UILabel *detailLable;
@property (nonatomic, readonly) UILabel *ratingLable;
@property (nonatomic, readonly) UIButton *detailButton;
@end

@implementation OrderCell
@synthesize billNumLable = _billNumLable;
@synthesize timeLable = _timeLable;
@synthesize detailLable = _detailLable;
@synthesize ratingLable = _ratingLable;
@synthesize detailButton = _detailButton;

#pragma mark - 生命周期
-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setupUI];
}

-(void)update
{
    [super update];
    Order *order = self.rowDescriptor.value;
    self.billNumLable.attributedText = [order.orderId attributedStringWithTitle:@"订单号："];
    self.ratingLable.attributedText = [[LinkUtil.orderStatus objectForKey:@(order.status)] attributedStringWithTitle:@"状态："];
    self.timeLable.attributedText = [[[LinkUtil dateFormatter] stringFromDate:order.updateTime] attributedStringWithTitle:@"下单时间："];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 80;
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }
    else if (self.rowDescriptor.action.formSelector){
        [controller performFormSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
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
                [controller.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
    }
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

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    return dateFormatter;
}

#pragma mark - UI
-(void)setupUI
{
    [self.contentView addSubview:self.ratingLable];
    [self.ratingLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.contentView addSubview:self.billNumLable];
    [self.billNumLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.bottom.equalTo(self.ratingLable.top).offset(-5);
    }];
    
    [self.contentView addSubview:self.timeLable];
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.ratingLable.bottom).offset(5);
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
    }
    return _timeLable;
}

-(UILabel *)detailLable
{
    if (!_detailLable) {
        _detailLable = [UILabel new];
    }
    return _detailLable;
}

-(UILabel *)ratingLable
{
    if (!_ratingLable) {
        _ratingLable = [UILabel new];
    }
    return _ratingLable;
}

-(UIButton *)detailButton
{
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.backgroundColor = ButtonColor;
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:@"查看详情" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        [_detailButton setAttributedTitle:attStr forState:UIControlStateNormal];
        _detailButton.layer.masksToBounds = YES;
        _detailButton.layer.cornerRadius = 6;
    }
    return _detailButton;
}

@end

@implementation PendingOrderCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:PendingOrderDescriporType];
}
@end

@implementation CompletionOrderCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:CompletionOrderDescriporType];
}
@end