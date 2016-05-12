//
//  OrderCell.h
//  Linkage
//
//  Created by Mac mini on 16/5/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "FormDescriptorCell.h"
extern NSString *const PendingOrderDescriporType;
extern NSString *const CompletionOrderDescriporType;

@interface OrderCell : XLFormBaseCell<FormDescriptorCell>

@end

@interface PendingOrderCell : OrderCell

@end

@interface CompletionOrderCell : OrderCell

@end