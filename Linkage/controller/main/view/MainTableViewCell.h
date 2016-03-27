//
//  MainTableViewCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/6.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString *const CompanyDescriporType;

@interface MainTableViewCell : XLFormBaseCell

@end


@interface CompanyTableCell : MainTableViewCell
@property (nonatomic, readonly) UIImageView *iconView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *subTitleLabel;
@property (nonatomic, readonly) UIView *ratingView;
@property (nonatomic, readonly) UIButton *button;

@end