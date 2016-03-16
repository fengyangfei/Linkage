//
//  MenuTableViewCell.m
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "MenuItem.h"
NSString *const FormRowDescriptorTypeMine = @"mineRowCell";
NSString *const FormRowDescriptorTypeMineHeader = @"mineHeaderRowCell";
@implementation MenuBaseTableViewCell
@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;

+(void)load
{
    NSDictionary *dic = @{
                          FormRowDescriptorTypeMine:[MenuTableViewCell class],
                          FormRowDescriptorTypeMineHeader:[MenuHeaderTableViewCell class]
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
    if (self.rowDescriptor.action.viewControllerClass) {
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

#pragma mark - 属性
-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
    }
    return _iconView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}
@end

@implementation MenuTableViewCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(@(24));
        make.height.equalTo(@(24));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(3);
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

@interface MenuHeaderTableViewCell()
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation MenuHeaderTableViewCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(8);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(@(52));
        make.height.equalTo(@(52));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(5);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.iconView.top);
    }];
    
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(5);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.iconView.bottom);
    }];
}

-(void)update
{
    [super update];
    MenuItem *item = self.rowDescriptor.value;
    self.iconView.image = [UIImage imageNamed:@"logo"];
    self.titleLabel.text = item.title;
    self.subTitleLabel.text = @"电话:150111111111";
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 65;
}

-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subTitleLabel;
}

-(UIImageView *)iconView
{
    UIImageView *imageView = super.iconView;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 6;
    return imageView;
}

@end
