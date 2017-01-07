//
//  VCFavorCell.m
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorCell.h"
#import "VCFavor.h"
#import "LinkUtil.h"
#import "NSDate+Format.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const VCFavorDescriporType = @"VCFavorDescriporType";

@interface VCFavorCell()
@property (nonatomic, readonly) UIImageView *iconView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UILabel *subDetailLabel;
@property (nonatomic, readonly) UILabel *countLabel;
@end

@implementation VCFavorCell
@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;
@synthesize subDetailLabel = _subDetailLabel;
@synthesize countLabel = _countLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:VCFavorDescriporType];
}

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
    VCFavor *favor = self.rowDescriptor.value;
    //    [self.iconView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"地区"]];
    [self.iconView setImage:[UIImage imageNamed:@"website"]];
    self.titleLabel.text = favor.title;
    self.detailLabel.text = favor.url;
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
        make.top.equalTo(self.contentView.top).offset(12);
        make.left.equalTo(self.contentView.left).offset(12);
        make.width.equalTo(18);
        make.height.equalTo(18);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(10);
        make.left.equalTo(self.iconView.right).offset(12);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.bottom).offset(5);
        make.left.equalTo(self.contentView.left).offset(12);
        make.right.equalTo(self.contentView.right).offset(-12);
    }];
}

-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = [UIColor lightGrayColor];
    }
    return _detailLabel;
}

-(UILabel *)subDetailLabel
{
    if (!_subDetailLabel) {
        _subDetailLabel = [UILabel new];
        _subDetailLabel.font = [UIFont systemFontOfSize:12];
        _subDetailLabel.numberOfLines = 0;
        _subDetailLabel.textColor = [UIColor lightGrayColor];
    }
    return _subDetailLabel;
}

-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = [UIColor lightGrayColor];
    }
    return _countLabel;
}


@end
