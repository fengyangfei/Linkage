//
//  BillDataSource.m
//  Linkage
//
//  Created by lihaijian on 16/3/15.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "BillDataSource.h"
#import "BillTableViewCell.h"

@implementation BillDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"已接单";
    }else{
        return @"未接单";
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todocell"];
    if (!cell) {
        cell = [[CompanyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"todocell"];
    }
    cell.billNumLable.text = @"订单号：1101";
    cell.timeLable.text = @"2015年7月6日";
    cell.detailLable.text = @"A承运商 张三 7月7日 14：00 已接单";
    cell.ratingLable.text = @"80%";
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end

@implementation TodoDataSource

@end

@implementation DoneDataSource

@end
