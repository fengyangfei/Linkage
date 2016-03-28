//
//  FormDescriptorCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/27.
//  Copyright © 2016年 LA. All rights reserved.
//
#import <XLForm/XLFormDescriptorCell.h>
@protocol FormDescriptorCell<XLFormDescriptorCell>
@optional

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController *)controller;

@end