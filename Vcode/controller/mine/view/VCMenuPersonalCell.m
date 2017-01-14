//
//  VCMenuPersonalCell.m
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCMenuPersonalCell.h"
NSString *const VCFormRowDescriptorTypePesonalHeader = @"vcMineHeaderRowCell";
@implementation VCMenuPersonalCell

+(void)load
{
    NSDictionary *dic = @{
                          VCFormRowDescriptorTypePesonalHeader:[self class]
                          };
    [XLFormViewController.cellClassesForRowDescriptorTypes addEntriesFromDictionary:dic];
}

-(void)update
{
    self.titleLabel.text = VCThemeString(@"completeInfoHint");
}

-(UILabel *)titleLabel
{
    UILabel *label = [super titleLabel];
    label.textColor = IndexTitleFontColor;
    label.font = [UIFont systemFontOfSize:16];
    return label;
}

@end
