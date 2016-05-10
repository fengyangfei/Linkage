//
//  BillTableViewCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/15.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "FormDescriptorCell.h"

extern NSString *const TodoBillDescriporType;
extern NSString *const DoneBillDescriporType;

@interface BillTableViewCell : XLFormBaseCell<FormDescriptorCell>

@end

@interface CompanyTableViewCell : BillTableViewCell

@end

@interface SubCompanyTableViewCell : BillTableViewCell

@end