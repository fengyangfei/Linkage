//
//  BillDetailViewController.h
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BaseBillViewController.h"

@interface BillDetailViewController : BaseBillViewController

//添加司机(方法发布给数据源使用)
-(void)addDriverRow:(XLFormRowDescriptor *)row;

@end
