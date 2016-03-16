//
//  CargoFormCell.h
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString * const kCargoRowDescriptroType;

@interface CargoFormCell : XLFormBaseCell

@property (nonatomic, readonly) UIButton *leftButton;
@property (nonatomic, readonly) UITextField *rightTextField;

@end
