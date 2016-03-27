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

@property (nonatomic, strong) UILabel *billNumLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *detailLable;
@property (nonatomic, strong) UILabel *ratingLable;

@end


@interface CompanyTableViewCell : BillTableViewCell

@end

@interface SubCompanyTableViewCell : BillTableViewCell

@end