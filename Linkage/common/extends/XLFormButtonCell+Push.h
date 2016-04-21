//
//  XLFormButtonCell+Push.h
//  YGTravel
//
//  Created by Mac mini on 16/4/8.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "FormDescriptorCell.h"

@interface XLFormButtonCell (Push)

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController<FormViewController> *)controller;

@end
