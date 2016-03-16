//
//  MenuTableViewCell.h
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>

extern NSString *const FormRowDescriptorTypeMine;
extern NSString *const FormRowDescriptorTypeMineHeader;

@interface MenuBaseTableViewCell : XLFormBaseCell
@property (nonatomic, readonly) UIImageView *iconView;
@property (nonatomic, readonly) UILabel *titleLabel;

@end

@interface MenuTableViewCell : MenuBaseTableViewCell

@end

@interface MenuHeaderTableViewCell : MenuBaseTableViewCell
@end