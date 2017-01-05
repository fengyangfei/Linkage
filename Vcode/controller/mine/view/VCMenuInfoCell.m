//
//  VCMenuInfoCell.m
//  Linkage
//
//  Created by lihaijian on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCMenuInfoCell.h"
#import "MenuItem.h"
NSString *const FormRowDescriptorTypeMenuInfo = @"VCInfoRowCell";

@implementation VCMenuInfoCell
+(void)load
{
    NSDictionary *dic = @{
                          FormRowDescriptorTypeMenuInfo:[self class],
                          };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:dic];
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
    infoLabel.textAlignment = NSTextAlignmentRight;
    self.accessoryView = infoLabel;
    self.editingAccessoryView = self.accessoryView;
}

- (void)update
{
    [super update];
    MenuItem *item = self.rowDescriptor.value;
    self.labelControl.text = item.value;
}

- (UILabel *)labelControl
{
    return (UILabel *)self.accessoryView;
}

@end
