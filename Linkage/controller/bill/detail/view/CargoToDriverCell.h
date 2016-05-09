//
//  CargoToDriverCell.h
//  Linkage
//
//  Created by Mac mini on 16/5/9.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "FormDescriptorCell.h"

extern NSString *const DriverInfoDescriporType;
extern NSString *const DriverEditDescriporType;

@interface DriverBaseCell : XLFormBaseCell<FormDescriptorCell>
@end

@interface DriverEditCell : DriverBaseCell
@end

@interface DriverInfoCell : DriverBaseCell
@end