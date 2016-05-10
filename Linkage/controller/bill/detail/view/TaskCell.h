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

@interface TaskCell : XLFormBaseCell<FormDescriptorCell>
@end

@interface TaskEditCell : TaskCell
@end

@interface TaskInfoCell : TaskCell
@end