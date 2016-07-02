//
//  MainTableViewCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/6.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "AXRatingView.h"

extern NSString *const CompanyDescriporType;
extern NSString *const CompanyInfoDescriporType;

@interface MainTableViewCell : XLFormBaseCell
@property (nonatomic, readonly) UIImageView *iconView;
@property (nonatomic, readonly) UILabel *titleLabel;
@end


@interface CompanyTableCell : MainTableViewCell
@property (nonatomic, readonly) UILabel *subTitleLabel;
@property (nonatomic, readonly) AXRatingView *ratingView;
@property (nonatomic, readonly) UIButton *button;

@end

@interface CompanyInfoTableCell : MainTableViewCell
@end