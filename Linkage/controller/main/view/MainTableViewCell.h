//
//  MainTableViewCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/6.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@end


@interface CompanyTableCell : MainTableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *ratingView;
@property (nonatomic, strong) UIButton *button;

@end