//
//  MessageTableCell.m
//  Linkage
//
//  Created by lihaijian on 16/4/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MessageTableCell.h"
#import "Message.h"
#import "LinkUtil.h"

NSString *const MessageDescriporType = @"MessageDescriporType";

@interface MessageTableCell()
@property (nonatomic, readonly) UILabel *titleLable;
@property (nonatomic, readonly) UILabel *timeLable;
@property (nonatomic, readonly) UILabel *detailLable;
@end

@implementation MessageTableCell
@synthesize titleLable = _titleLable;
@synthesize timeLable = _timeLable;
@synthesize detailLable = _detailLable;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:MessageDescriporType];
}

#pragma mark - 生命周期
-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
}

-(void)update
{
    Message *message = self.rowDescriptor.value;
    [super update];
    self.titleLable.text = message.title;
    self.timeLable.text = [LinkUtil.dateFormatter stringFromDate:message.createTime];
    self.detailLable.text = message.introduction;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 65;
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
    [self.contentView addSubview:self.titleLable];
    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.contentView.top).offset(5);
    }];
    
    [self.contentView addSubview:self.timeLable];
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.top.equalTo(self.contentView.top).offset(5);
    }];
    
    [self.contentView addSubview:self.detailLable];
    [self.detailLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.titleLable.bottom).offset(5);
        make.right.equalTo(self.contentView.right).offset(-12);
    }];
}

-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont boldSystemFontOfSize:12];
    }
    return _titleLable;
}

-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:12];
        _timeLable.textAlignment = NSTextAlignmentRight;
    }
    return _timeLable;
}

-(UILabel *)detailLable
{
    if (!_detailLable) {
        _detailLable = [UILabel new];
        _detailLable.font = [UIFont systemFontOfSize:12];
        _detailLable.textColor = [UIColor lightGrayColor];
        _detailLable.numberOfLines = 0;
    }
    return _detailLable;
}
@end