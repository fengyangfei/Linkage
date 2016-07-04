//
//  TaskCell.h
//  Linkage
//
//  Created by Mac mini on 16/5/10.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
#import "FormDescriptorCell.h"

extern NSString *const TaskInfoDescriporType;
extern NSString *const TaskEditDescriporType;
extern NSString *const TaskAddDescriporType;


@interface TaskCell : XLFormBaseCell<FormDescriptorCell>
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@end

@interface TaskAddCell : TaskCell
@end

@interface TaskEditCell : TaskCell
@end

@interface TaskInfoCell : TaskCell
@end