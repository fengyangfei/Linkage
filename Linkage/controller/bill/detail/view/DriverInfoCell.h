//
//  DriverInfoCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "FormDescriptorCell.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>

extern NSString *const DriverInfoDescriporType;

@interface DriverInfoCell : MGSwipeTableCell<FormDescriptorCell>

@property (nonatomic, weak) XLFormRowDescriptor * rowDescriptor;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIButton *button;

@end
