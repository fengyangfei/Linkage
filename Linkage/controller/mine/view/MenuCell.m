//
//  MenuTableViewCell.m
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MenuCell.h"
#import "MenuItem.h"
#import "LoginUser.h"
#import "Company.h"
#import "UIImageView+Cache.h"
#import "ModelBaseViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const FormRowDescriptorTypeMine = @"mineRowCell";
NSString *const FormRowDescriptorTypeMineHeader = @"mineHeaderRowCell";
@implementation MenuBaseTableViewCell
@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;

+(void)load
{
    NSDictionary *dic = @{
                          FormRowDescriptorTypeMine:[MenuCell class],
                          FormRowDescriptorTypeMineHeader:[MenuInfoCell class]
                          };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:dic];
}

-(void)configure
{
    [super configure];
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

- (void)update
{
    [super update];
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    MenuItem *item = self.rowDescriptor.value;
    if (self.rowDescriptor.action.viewControllerClass) {
        UIViewController * controllerToPresent;
        if ([self.rowDescriptor.action.viewControllerClass isSubclassOfClass:[ModelBaseViewController class]]) {
            controllerToPresent = [[self.rowDescriptor.action.viewControllerClass alloc] initWithControllerType:ControllerTypeManager];
        }else{
            controllerToPresent = [[self.rowDescriptor.action.viewControllerClass alloc] init];
        }
        if (controllerToPresent){
            if ([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
                ((UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent).rowDescriptor = self.rowDescriptor;
            }
            if (controller.navigationController == nil || [controllerToPresent isKindOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == XLFormPresentationModePresent){
                [controller presentViewController:controllerToPresent animated:YES completion:nil];
            }
            else{
                controllerToPresent.title = item.title;
                controllerToPresent.hidesBottomBarWhenPushed = YES;
                [controller.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
    }
}

#pragma mark - 属性
-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = IndexTitleFontColor;
    }
    return _titleLabel;
}
@end

//普通的Cell
@implementation MenuCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(@(16));
        make.height.equalTo(@(16));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(15);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

- (void)update
{
    [super update];
    MenuItem *item = self.rowDescriptor.value;
    self.iconView.image = item.icon;
    self.titleLabel.text = item.title;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 45;
}

@end

//公司与个人的Cell
@interface MenuInfoCell()
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation MenuInfoCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(@(64));
        make.height.equalTo(@(64));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(14);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.iconView.top).offset(10);
    }];
    
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(14);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.iconView.bottom).offset(-10);
    }];
}

-(void)update
{
    [super update];
    MenuItem *item = self.rowDescriptor.value;
    [item isKindOfClass:[self class]];
    if ([item.entityName isEqualToString:@"LoginUser"]) {
        LoginUser *user = [LoginUser shareInstance];
        if (user) {
            if (user.icon) {
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.icon]];
            }
            self.titleLabel.text = NilStringWrapper(user.userName);
            self.subTitleLabel.text = NilStringWrapper(user.mobile);
        }else{
            self.iconView.image = [UIImage imageNamed:@"user_header"];
            self.titleLabel.text = @"登录名";
            self.subTitleLabel.text = @"电话信息";
        }
    }
    else if ([item.entityName isEqualToString:@"Company"]) {
        Company *company = [Company shareInstance];
        if (company) {
            if (company.logo) {
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:company.logo]];
            }
            self.titleLabel.text = company.companyName;
            self.subTitleLabel.text = company.address;
        }else{
            self.iconView.image = [UIImage imageNamed:@"user_header"];
            self.titleLabel.text = @"公司名称";
            self.subTitleLabel.text = @"详细信息";
        }
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 82;
}

-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = IndexTitleFontColor;
    }
    return _subTitleLabel;
}

-(UIImageView *)iconView
{
    UIImageView *imageView = super.iconView;
    imageView.image = [UIImage imageNamed:@"user_header"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 6;
    return imageView;
}

-(UILabel *)titleLabel
{
    UILabel *label = [super titleLabel];
    label.textColor = HeaderColor;
    label.font = [UIFont systemFontOfSize:18];
    return label;
}

@end
