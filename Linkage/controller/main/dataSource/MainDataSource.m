//
//  MainDataSource.m
//  Linkage
//
//  Created by lihaijian on 16/3/6.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MainDataSource.h"
#import "MainTableViewCell.h"

#define kFactoryCellIndentifier @"kFactoryCellIndentifier"
@implementation MainDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FactoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kFactoryCellIndentifier];
    if (!cell) {
        cell = [[FactoryTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFactoryCellIndentifier];
    }
    
    cell.iconView.image = [UIImage imageNamed:@"logo"];
    cell.titleLabel.text = @"供货商";
    cell.subTitleLabel.text  = @"日期";
    return cell;
}

@end

@implementation FactoryDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
