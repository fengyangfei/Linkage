//
//  BillApplyViewController.h
//  Linkage
//
//  Created by lihaijian on 16/3/17.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>

@interface BillApplyViewController : XLFormViewController

@end

//进口订单
@interface BillImportApplyViewController : BillApplyViewController

@end

//出口订单
@interface BillExportApplyViewController : BillApplyViewController

@end

//自备柜配送订单
@interface BillCustomApplyViewController : BillApplyViewController

@end