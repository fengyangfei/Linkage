//
//  BillDataSource.h
//  Linkage
//
//  Created by lihaijian on 16/3/15.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BillDataSource;
@protocol BillDataSourceDelegate <NSObject>
@optional
-(UIViewController *)formControllerOfDataSource:(BillDataSource*)dataSource;
-(UITableView *)tableViewOfDataSource:(BillDataSource*)dataSource;
@end

@interface BillDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) XLFormDescriptor *form;
@property (nonatomic, weak) id<BillDataSourceDelegate> dataSourceDelegate;
@end


@interface TodoDataSource : BillDataSource

@end

@interface DoneDataSource : BillDataSource

@end