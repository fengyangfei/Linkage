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
#import "BillApplyViewController.h"
#import "OrderUtil.h"
#import "Comment.h"
#import "CommentViewController.h"
#import "NSDate+Format.h"

NSString *const PendingOrderDescriporType = @"PendingOrderRowType";
NSString *const CompletionOrderDescriporType = @"CompletionOrderRowType";

@interface OrderCell()
@property (nonatomic, readonly) UILabel *billNumLable;
@property (nonatomic, readonly) UILabel *timeLable;
@property (nonatomic, readonly) UILabel *detailLable;
@property (nonatomic, readonly) UILabel *ratingLable;
@property (nonatomic, readonly) UIButton *detailButton;
@property (nonatomic, readonly) UILabel *statusLable;
@end

@implementation OrderCell
@synthesize billNumLable = _billNumLable;
@synthesize timeLable = _timeLable;
@synthesize detailLable = _detailLable;
@synthesize ratingLable = _ratingLable;
@synthesize detailButton = _detailButton;
@synthesize statusLable = _statusLable;

#pragma mark - 生命周期
-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setupUI];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 60;
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

-(UIViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - UI
-(void)setupUI
{
}

-(UILabel *)billNumLable
{
    if (!_billNumLable) {
        _billNumLable = [UILabel new];
        _billNumLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _billNumLable;
}

-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.textColor = OrderDetailFontColor;
        _timeLable.font = OrderDetailFont;
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
        _ratingLable.textColor = OrderDetailFontColor;
        _ratingLable.font = OrderDetailFont;
    }
    return _ratingLable;
}

-(UILabel *)statusLable
{
    if (!_statusLable) {
        _statusLable = [UILabel new];
        _statusLable.textColor = HeaderColor;
        _statusLable.font = OrderDetailFont;
        _statusLable.textAlignment = NSTextAlignmentRight;
    }
    return _statusLable;
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

//未完成订单cell
@implementation PendingOrderCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:PendingOrderDescriporType];
}

-(void)update
{
    [super update];
    Order *order = self.rowDescriptor.value;
    self.billNumLable.attributedText = [order.orderId attributedStringWithTitle:@"订单号："];
    self.ratingLable.text = order.companyName;
    self.statusLable.text = [LinkUtil.orderStatus objectForKey:@(order.status)];
    self.timeLable.text = [order.updateTime stringFromDate];
}

-(void)setupUI
{
    [self.contentView addSubview:self.statusLable];
    [self.statusLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.top.equalTo(self.contentView.top).offset(12);
    }];
    
    [self.contentView addSubview:self.billNumLable];
    [self.billNumLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.top.equalTo(self.contentView.top).offset(12);
        make.right.equalTo(self.statusLable.left);
    }];
    
    [self.contentView addSubview:self.ratingLable];
    [self.ratingLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.bottom.equalTo(self.contentView.bottom).offset(-12);
    }];
    
    [self.contentView addSubview:self.timeLable];
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.bottom.equalTo(self.contentView.bottom).offset(-12);
    }];
}
@end

//已完成订单Cell
@interface CompletionOrderCell()
@property (nonatomic, readonly) UIButton *button;
@end

@implementation CompletionOrderCell
@synthesize button = _button;
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:CompletionOrderDescriporType];
}

-(void)update
{
    [super update];
    Order *order = self.rowDescriptor.value;
    self.billNumLable.attributedText = [order.orderId attributedStringWithTitle:@"订单号："];
    self.ratingLable.text = [NSString stringWithFormat:@"%@  %@",order.companyName, [order.updateTime stringFromDate]];
    if (order && order.comment && StringIsNotEmpty(order.comment.commentId)) {
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"查看评论" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:IndexButtonColor}];
        [self.button setAttributedTitle:title forState:UIControlStateNormal];
    }else{
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"评  价" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:IndexButtonColor}];
        [self.button setAttributedTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark - UI
-(void)setupUI
{
    [self.contentView addSubview:self.billNumLable];
    [self.billNumLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.top.equalTo(self.contentView.top).offset(12);
    }];
    
    [self.contentView addSubview:self.ratingLable];
    [self.ratingLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.bottom.equalTo(self.contentView.bottom).offset(-12);
    }];
    
    [self.contentView addSubview:self.button];
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
}

-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"评  价" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:IndexButtonColor}];
        [_button setAttributedTitle:title forState:UIControlStateNormal];
        [_button setBackgroundImage:ButtonFrameImage forState:UIControlStateNormal];
        [_button setBackgroundImage:ButtonFrameImage forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(void)clickAction:(id)sender
{
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.rowDescriptor = self.rowDescriptor;
    [self.formViewController.navigationController pushViewController:commentVC animated:YES];
}
@end