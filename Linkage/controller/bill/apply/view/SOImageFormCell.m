//
//  SOImageFormCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "SOImageFormCell.h"
#import "SOImageModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+Cache.h"
#import "ImageCacheManager.h"

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
    SOImageModel *model = (SOImageModel *)self.rowDescriptor.value;
    if (model.photo) {
        self.imageView.image = model.photo;
    }else{
        [self.imageView imageWithCacheKey:model.photoName];
    }
    self.nameLabel.text = model.photoName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    self.dateLabel.text = [formatter stringFromDate:model.createDate];
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
            SOImageModel *model = (SOImageModel *)row.value;
            MJPhoto *photo = ({
                MJPhoto *photo = [[MJPhoto alloc] init];
                if(model.photo){
                    photo.image = model.photo;
                }else{
                    __weak __typeof(photo) weakPhoto = photo;
                    [[ImageCacheManager sharedManger] queryDiskCacheForKey:model.photoName done:^(UIImage *image, SDImageCacheType cacheType) {
                        weakPhoto.image = image;
                    }];
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
