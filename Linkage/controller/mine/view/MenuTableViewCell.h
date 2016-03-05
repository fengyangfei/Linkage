//
//  MenuTableViewCell.h
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"
@class MineViewController;

@interface MenuBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)updateUI:(MenuItem *)item;
- (void)cellDidSelectedWithController:(MineViewController *)controller;

@end

@interface MenuTableViewCell : MenuBaseTableViewCell

@end


@interface MenuHeaderTableViewCell : MenuBaseTableViewCell
@end