//
//  ImageInfoCell.m
//  Linkage
//
//  Created by lihaijian on 16/6/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "ImageInfoCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const ImageInfoDescriporTypeCell = @"ImageInfoRowType";

@implementation ImageInfoCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:ImageInfoDescriporTypeCell];
}

#pragma mark - cell的初始化与更新
-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
}

-(void)update
{
    [super update];
    self.textLabel.textColor = IndexTitleFontColor;
    self.textLabel.text = self.rowDescriptor.title;
    NSString *imageUrl = self.rowDescriptor.value;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
}

- (UIImageView *)imageView
{
    return (UIImageView *)self.accessoryView;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 65.0;
}

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController *)controller
{
    MJPhoto *photo = [[MJPhoto alloc] init];
    NSString *imageUrl = self.rowDescriptor.value;
    photo.url = [NSURL URLWithString:imageUrl];
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}

@end
