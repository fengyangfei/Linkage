//
//  BillTableViewCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/15.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillTableViewCell.h"
#import "Order.h"

NSString *const TodoBillDescriporType = @"TodoBillRowType";
NSString *const DoneBillDescriporType = @"DoneBillRowType";

@implementation NSString (BillInfo)

-(NSAttributedString *)attributedStringWithTitle:(NSString *)title
{
    NSMutableAttributedString *titleString = [[[NSAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}] mutableCopy];
    NSAttributedString *valueString = [[NSAttributedString alloc]initWithString:self attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [titleString appendAttributedString:valueString];
    return [titleString copy];
}

@end

@interface BillTableViewCell()

@property (nonatomic, readonly) UILabel *billNumLable;
@property (nonatomic, readonly) UILabel *timeLable;
@property (nonatomic, readonly) UILabel *detailLable;
@property (nonatomic, readonly) UILabel *ratingLable;
@property (nonatomic, readonly) UIButton *detailButton;
@end

@implementation BillTableViewCell
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
    self.ratingLable.attributedText = [order.deliveryAddress attributedStringWithTitle:@"进度："];
    self.timeLable.attributedText = [[[BillTableViewCell dateFormatter] stringFromDate:order.updateTime] attributedStringWithTitle:@"下单时间："];
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
    
//    [self.contentView addSubview:self.detailButton];
//    [self.detailButton makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.right).offset(-12);
//        make.centerY.equalTo(self.contentView.centerY);
//        make.height.equalTo(@28);
//        make.width.equalTo(@80);
//    }];
    
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
