//
//  SOImageFormCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString *const SOImageRowDescriporType;
@interface SOImageFormCell : XLFormBaseCell

@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,readonly) UILabel *nameLabel;
@property (nonatomic,readonly) UILabel *dateLabel;

@end
