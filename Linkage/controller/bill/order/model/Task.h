//
//  Task.h
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"

@interface Task : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (nonatomic,copy  ) NSString *taskId;
@property (nonatomic,copy  ) NSString *driverId;
@property (nonatomic,copy  ) NSString *driverName;
@property (nonatomic,copy  ) NSString *driverLicense;
@property (nonatomic,copy  ) NSString *cargoNo;//货柜号
@property (nonatomic,strong) NSNumber *cargoType;//货柜类型
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSDate   *updateTime;
@end

@class Driver;
@class Cargo;
@interface Task(Operation)
+ (Task*)createWithDriver:(Driver *)driver cargo:(Cargo *)cargo;
@end