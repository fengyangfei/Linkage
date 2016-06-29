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
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const MessageDescriporType = @"MessageDescriporType";

@interface MessageTableCell()
@property (nonatomic, readonly) UIImageView *iconView;
@property (nonatomic, readonly) UILabel *titleLable;
@property (nonatomic, readonly) UILabel *detailLable;
@property (nonatomic, readonly) UILabel *timeLable;
@end

@implementation MessageTableCell
@synthesize iconView = _iconView;
@synthesize titleLable = _titleLable;
@synthesize detailLable = _detailLable;
@synthesize timeLable = _timeLable;

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
    [super update];
    Message *message = self.rowDescriptor.value;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:message.icon] placeholderImage:nil];
    self.titleLable.text = message.title;
    self.detailLable.text = message.introduction;
    self.timeLable.text = [LinkUtil.dateFormatter stringFromDate:message.createTime];
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
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(12);
        make.width.equalTo(45);
        make.height.equalTo(45);
    }];
    
    [self.contentView addSubview:self.titleLable];
    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(12);
        make.top.equalTo(self.iconView.top);
    }];
    
    [self.contentView addSubview:self.detailLable];
    [self.detailLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(12);
        make.bottom.equalTo(self.iconView.bottom);
    }];
    
    [self.contentView addSubview:self.timeLable];
    [self.timeLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.bottom.equalTo(self.iconView.bottom);
    }];
}

-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont boldSystemFontOfSize:16];
        _titleLable.textColor = IndexTitleFontColor;
    }
    return _titleLable;
}

-(UILabel *)detailLable
{
    if (!_detailLable) {
        _detailLable = [UILabel new];
        _detailLable.font = [UIFont systemFontOfSize:14];
        _detailLable.textColor = [UIColor lightGrayColor];
        _detailLable.numberOfLines = 0;
        _detailLable.textColor = IndexTitleFontColor;
    }
    return _detailLable;
}

-(UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textAlignment = NSTextAlignmentRight;
        _timeLable.textColor = IndexTitleFontColor;
    }
    return _timeLable;
}

@end