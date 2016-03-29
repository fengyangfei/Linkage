//
//  DriverInfoCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverInfoCell.h"
#import <MGSwipeTableCell/MGSwipeButton.h>
NSString *const DriverInfoDescriporType = @"DriverInfoRowType";;

@implementation DriverInfoCell

@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:DriverInfoDescriporType];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

-(void)configure
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
    MGSwipeButton *rightButton = [MGSwipeButton buttonWithTitle:@"打单" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        return YES;
    }];
    self.rightButtons = @[rightButton];
    self.rightSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;
}

-(void)update
{
    self.textLabel.text = @"司机A";
    self.detailLabel.text = @"车牌：粤C88888";
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 65;
}

#pragma mark - UI
-(void)setupUI
{
    [self.contentView addSubview:self.textLabel];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.centerY);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(12);
        make.top.equalTo(self.contentView.centerY);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
    }
    return _textLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _detailLabel;
}


@end
