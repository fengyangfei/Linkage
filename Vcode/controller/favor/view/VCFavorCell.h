//
//  VCFavorCell.h
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>

extern NSString *const VCFavorDescriporType;
@interface VCFavorCell : MGSwipeTableCell<XLFormDescriptorCell>
@property (nonatomic, weak) XLFormRowDescriptor * rowDescriptor;
-(XLFormViewController *)formViewController;
@end
