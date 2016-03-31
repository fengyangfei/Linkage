//
//  Order.h
//  Linkage
//
//  Created by lihaijian on 16/3/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeExport,
    OrderTypeImport,
    OrderTypeCustom
};

typedef NS_ENUM(NSUInteger, OrderStatus) {
    OrderStatusUnDo,
    OrderStatusDoing,
    OrderStatusDone
};

//订单
@interface Order : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) OrderType type;
@property (nonatomic, copy) NSString *manufactureId;//生产商ID
@property (nonatomic, copy) NSString *transporterId;//输送商ID
@property (nonatomic, copy) NSString *manufactureContactName;//厂商联系人
@property (nonatomic, copy) NSString *manufactureContactTel;//厂商电话
@property (nonatomic, copy) NSString *transporterContactName;//输送联系人
@property (nonatomic, copy) NSString *transporterContractTel;//输送人电话
@property (nonatomic, copy) NSString *takeAddress;//运输地址
@property (nonatomic, strong) NSDate *takeTime;
@property (nonatomic, copy) NSString *deliveryAddress;//交货地址
@property (nonatomic, strong) NSDate *deliverTime;//交货时间
@property (nonatomic, strong) NSDate *cargosCentExpire;
@property (nonatomic, copy) NSString *memo;//备注
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, assign) OrderStatus status;
@property (nonatomic, copy) NSString *userId;
@end

//进口订单
@interface ImportOrder : Order
@property (nonatomic, copy) NSString *billNo;
@property (nonatomic, copy) NSString *customsBroker;//海关代理人
@property (nonatomic, copy) NSString *customsHouseContact;
@property (nonatomic, copy) NSString *cargoCompany;
@end

//出口订单
@interface ExportOrder : Order
@property (nonatomic, copy) NSString *so;//图片
@property (nonatomic, copy) NSString *customsIn;
@property (nonatomic, copy) NSString *shipCompany;
@property (nonatomic, copy) NSString *shipName;
@property (nonatomic, copy) NSString *shipScheduleNo;
@property (nonatomic, assign) BOOL  isBookCargo;
@end

typedef NS_ENUM(NSUInteger, DriverTaskStatus) {
    DriverTaskStatusWait,
    DriverTaskStatusDone
};
//司机任务
@interface DriverTask : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *orderId;
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
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@end

//司机任务
@interface DriverTaskHistory : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@end