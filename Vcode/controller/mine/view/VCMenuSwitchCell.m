//
//  VCMenuSwitchCell.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCMenuSwitchCell.h"

NSString *const FormRowDescriptorTypeMenuSwitch = @"vcSwitchRowCell";

@implementation VCMenuSwitchCell

+(void)load
{
    NSDictionary *dic = @{
                          FormRowDescriptorTypeMenuSwitch:[self class],
                          };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:dic];
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = [[UISwitch alloc] init];
    self.editingAccessoryView = self.accessoryView;
    [self.switchControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    self.switchControl.on = NO;
}

- (UISwitch *)switchControl
{
    return (UISwitch *)self.accessoryView;
}

- (void)valueChanged
{
    //@(self.switchControl.on);
}

@end
