//
//  MenuTableViewCell.m
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "MineViewController.h"

@interface MenuBaseTableViewCell()
@property (nonatomic, readonly) MenuItem *item;
@end

@implementation MenuBaseTableViewCell
@synthesize item= _item;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

- (void)updateUI:(MenuItem *)item
{
    _item = item;
}

- (void)cellDidSelectedWithController:(MineViewController *)controller
{
    if (_item) {
        UIViewController *viewController = [[self.item.viewControllerClass alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:viewController animated:YES];
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

-(void)setupUI
{
    [super setupUI];
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

- (void)updateUI:(MenuItem *)item
{
    [super updateUI:item];
    self.iconView.image = item.icon;
    self.titleLabel.text = item.title;
}


@end

@interface MenuHeaderTableViewCell()
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation MenuHeaderTableViewCell

-(void)setupUI
{
    [super setupUI];
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

-(void)updateUI:(MenuItem *)item
{
    
    [super updateUI:item];
    if ([TRThemeManager shareInstance].themeType == TRThemeTypeFactory) {
        self.iconView.image = [UIImage imageNamed:@"logo"];
        self.titleLabel.text = @"小明";
        self.subTitleLabel.text = @"电话:150111111111";
    }
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
