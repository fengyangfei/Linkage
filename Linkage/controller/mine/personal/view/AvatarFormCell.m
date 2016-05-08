//
//  AvatarFormCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AvatarFormCell.h"
#import "UIViewController+TRImagePicker.h"
#import "SOImage.h"
#import "ImageCacheManager.h"
#import "YGRestClient.h"
#import "LoginUser.h"
#import "LinkUtil.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const AvatarDescriporType = @"AvatarRowType";
NSString *const CompanyLogoDescriporType = @"CompanyLogoRowType";

@implementation AvatarFormCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:AvatarDescriporType];
}

#pragma mark - cell的初始化与更新
-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self configureUI];
}

-(void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    if (self.rowDescriptor.value) {
        [self.imageView sd_setImageWithURL:self.rowDescriptor.value];
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 65.0;
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    WeakSelf
    [controller addSignalPhoto:^(UIImage *image, NSString *fileName) {
        [weakSelf.imageView setImage:image];
        weakSelf.rowDescriptor.value = fileName;
        [[ImageCacheManager sharedManger] diskImageExistsWithKey:fileName completion:^(BOOL isInCache) {
            [LinkUtil uploadWithUrl:UserIconUrl image:UIImageJPEGRepresentation(image, 0.75) name:fileName success:^(id responseObject) {
                LoginUser *user = [LoginUser shareInstance];
                user.icon = responseObject[@"result"][@"icon"];
                [user save];
            }];
            if (!isInCache) {
                [[ImageCacheManager sharedManger] storeImage:image forKey:fileName];
            }
        }];
    }];
}

#pragma mark - Properties

-(UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5;
    return _imageView;
}

-(UILabel *)textLabel
{
    if (_textLabel) {
        return _textLabel;
    }
    _textLabel = [UILabel new];
    _textLabel.font = [UIFont systemFontOfSize:16];
    return _textLabel;
}

-(void)configureUI
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(11);
        make.right.equalTo(self.contentView.right).offset(-8);
        make.height.equalTo(44);
        make.width.equalTo(44);
    }];
    
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(18);
        make.right.equalTo(self.imageView.left);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}

@end

@implementation CompanyLogoFormCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:CompanyLogoDescriporType];
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    WeakSelf
    [controller addSignalPhoto:^(UIImage *image, NSString *fileName) {
        [weakSelf.imageView setImage:image];
        weakSelf.rowDescriptor.value = fileName;
        [[ImageCacheManager sharedManger] diskImageExistsWithKey:fileName completion:^(BOOL isInCache) {
            [LinkUtil uploadWithUrl:CompanyLogoUrl image:UIImageJPEGRepresentation(image, 0.75) name:fileName success:^(id responseObject) {
                Company *company = [Company shareInstance];
                company.logo = responseObject[@"result"][@"icon"];
                [company save];
            }];
            if (!isInCache) {
                [[ImageCacheManager sharedManger] storeImage:image forKey:fileName];
            }
        }];
    }];
}

@end
