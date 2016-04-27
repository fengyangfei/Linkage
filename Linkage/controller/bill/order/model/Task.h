//
//  Task.h
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
typedef NS_ENUM(NSUInteger, DriverTaskStatus) {
    DriverTaskStatusWait,
    DriverTaskStatusDone
};

@interface Task : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@end

//司机任务
@interface DriverTask : Task
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *licence;
@property (nonatomic, copy) NSString *CargoNo;
@property (nonatomic, copy) NSString *CargoType;
@property (nonatomic, assign) DriverTaskStatus status;
@property (nonatomic, assign) BOOL isAccept;
@property (nonatomic, copy) NSString *rejectReason;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *image;

@end

//司机任务
@interface DriverTaskHistory : Task
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *image;
@end