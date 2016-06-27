//
//  SOImageFormCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SOImageFormCell.h"
#import "SOImage.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+Cache.h"
#import "ImageCacheManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const SOImageRowDescriporType = @"SOImageRowType";

@implementation SOImageFormCell
@synthesize imageView = _imageView;
@synthesize nameLabel = _nameLabel;
@synthesize dateLabel = _dateLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:SOImageRowDescriporType];
}

#pragma mark - cell的初始化与更新
-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self configureUI];
}

-(void)update
{
    [super update];
    
    if(self.rowDescriptor.value && [self.rowDescriptor.value isKindOfClass:[SOImage class]]){
        SOImage *model = (SOImage *)self.rowDescriptor.value;
        if (model.image) {
            self.imageView.image = model.image;
        }else if(model.imageName) {
            [self.imageView imageWithCacheKey:model.imageName];
        }else if (model.imageUrl) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        }
        self.nameLabel.text = model.imageName;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        self.dateLabel.text = [formatter stringFromDate:model.createDate];
    }else if (self.rowDescriptor.value && [self.rowDescriptor.value isKindOfClass:[NSString class]]){
        NSString *imageUrl = self.rowDescriptor.value;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 65.0;
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    NSInteger rowIndex = 0, currentIndex = 0;
    XLFormSectionDescriptor *section = self.rowDescriptor.sectionDescriptor;
    NSMutableArray * photoArray = [NSMutableArray new];
    for (XLFormRowDescriptor * row in section.formRows) {
        if (row.value){
            MJPhoto *photo = ({
                MJPhoto *photo = [[MJPhoto alloc] init];
                if ([row.value isKindOfClass:[SOImage class]]) {
                    SOImage *model = (SOImage *)row.value;
                    if(model.image){
                        photo.image = model.image;
                    }else{
                        __weak __typeof(photo) weakPhoto = photo;
                        [[ImageCacheManager sharedManger] queryDiskCacheForKey:model.imageName done:^(UIImage *image, SDImageCacheType cacheType) {
                            weakPhoto.image = image;
                        }];
                    }
                }else if([row.value isKindOfClass:[NSString class]]){
                    photo.url = [NSURL URLWithString:row.value];
                }
                photo;
            });
            [photoArray addObject:photo];
            if (row == self.rowDescriptor) {
                currentIndex = rowIndex;
            }
            rowIndex++;
        }
    }
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.photos = photoArray;
    photoBrowser.currentPhotoIndex = currentIndex;
    [photoBrowser show];
}

#pragma mark - Properties

-(UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [UIImageView new];
    [_imageView setUserInteractionEnabled:YES];
    return _imageView;
}

-(UILabel *)nameLabel
{
    if (_nameLabel) {
        return _nameLabel;
    }
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor grayColor];
    return _nameLabel;
}

-(UILabel *)dateLabel
{
    if(_dateLabel){
        return _dateLabel;
    }
    _dateLabel = [UILabel new];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor grayColor];
    return _dateLabel;
}

-(void)configureUI
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(11);
        make.left.equalTo(self.contentView.left).offset(16);
        make.height.equalTo(44);
        make.width.equalTo(44);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.right).offset(8);
        make.top.equalTo(self.imageView.top);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(20);
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.right).offset(10);
        make.bottom.equalTo(self.imageView.bottom);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(20);
    }];
}

@end
