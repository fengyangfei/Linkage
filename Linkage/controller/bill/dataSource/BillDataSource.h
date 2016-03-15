//
//  BillDataSource.h
//  Linkage
//
//  Created by lihaijian on 16/3/15.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@end


@interface TodoDataSource : BillDataSource

@end

@interface DoneDataSource : BillDataSource

@end