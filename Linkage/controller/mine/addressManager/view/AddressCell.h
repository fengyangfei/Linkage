//
//  AddressCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (nonatomic, readonly) UIButton *defaultAddrButton;
@property (nonatomic, readonly) UIButton *deleteButton;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@end
