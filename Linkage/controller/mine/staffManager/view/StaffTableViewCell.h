//
//  StaffTableViewCell.h
//  Linkage
//
//  Created by Mac mini on 16/6/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString *const StaffDescriporRowType;

@interface StaffTableViewCell : XLFormBaseCell
@property (nonatomic, readonly) UIImageView *iconView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *subTitleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@end
