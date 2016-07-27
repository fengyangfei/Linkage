//
//  CargoFormCell.h
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString * const kExportOrSelfCargoRowDescriptroType;
extern NSString * const kImportCargoRowDescriptroType;

@interface CargoFormCell : XLFormBaseCell

@property (nonatomic, readonly) UIButton *leftButton;
@property (nonatomic, readonly) UITextField *rightTextField;

@end
