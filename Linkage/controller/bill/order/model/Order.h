//
//  Order.h
//  Linkage
//
//  Created by lihaijian on 16/3/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeExport,
    OrderTypeImport,
    OrderTypeSelf,
    OrderTypeMainland
};

typedef NS_ENUM(NSUInteger, OrderStatus) {
    OrderStatusUnDo,
    OrderStatusDoing,
    OrderStatusDone
};

typedef NS_ENUM(NSUInteger, ObjectStatus) {
    Transient,//引用状态
    Persistent//持久状态
};

//订单
@interface Order : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing,ModelHttpParameter>
@property (nonatomic, copy  ) NSString     *orderId;//订单号
@property (nonatomic, assign) OrderType    type;//订单类型
@property (nonatomic, assign) OrderStatus  status;//订单状态
@property (nonatomic, copy  ) NSString     *companyId;//承运商ID
@property (nonatomic, copy  ) NSString     *userId;//创建人
@property (nonatomic, copy  ) NSString     *manufactureId;//生产商ID
@property (nonatomic, copy  ) NSString     *transporterId;//输送商ID
@property (nonatomic, copy  ) NSString     *manufactureContactName;//厂商联系人
@property (nonatomic, copy  ) NSString     *manufactureContactTel;//厂商电话
@property (nonatomic, copy  ) NSString     *transporterContactName;//输送联系人
@property (nonatomic, copy  ) NSString     *transporterContractTel;//输送人电话
@property (nonatomic, copy  ) NSString     *takeAddress;//运输地址
@property (nonatomic, strong) NSDate       *takeTime;//装货时间
@property (nonatomic, copy  ) NSString     *deliveryAddress;//交货地址
@property (nonatomic, strong) NSDate       *deliverTime;//交货时间
@property (nonatomic, strong) NSDate       *cargosRentExpire;//柜租到期日期
@property (nonatomic, copy  ) NSString     *memo;//备注
@property (nonatomic, strong) NSDate       *createTime;//创建时间
@property (nonatomic, strong) NSDate       *updateTime;//更新时间
@property (nonatomic, assign) BOOL         isTransferPort;//是否转关
@property (nonatomic, strong) NSArray      *cargos;//货柜
@property (nonatomic, assign) ObjectStatus objStatus;//对象状态
@end

//进口订单
@interface ImportOrder : Order
@property (nonatomic, copy) NSString *billNo;//提单号
@property (nonatomic, copy) NSString *cargoNo;//柜号
@property (nonatomic, copy) NSString *customsBroker;//报关行联系人
@property (nonatomic, copy) NSString *customsHouseContact;//报关行联系人电话
@property (nonatomic, copy) NSString *cargoCompany;//二程公司
@end

//出口订单
@interface ExportOrder : Order
@property (nonatomic, copy  ) NSString *so;//图片
@property (nonatomic, strong) NSDate   *customsIn;//截关日期
@property (nonatomic, copy  ) NSString *shipCompany;//头程公司
@property (nonatomic, copy  ) NSString *shipName;//头程船名
@property (nonatomic, copy  ) NSString *shipScheduleNo;//头程班次
@property (nonatomic, assign) BOOL     isBookCargo;//是否与头程越好柜
@property (nonatomic, copy  ) NSString *port;//港口
@property (nonatomic, strong) NSArray  *soImages;//so图片
@end

//自备柜订单
@interface SelfOrder : Order
@property (nonatomic, assign) BOOL   isCustomsDeclare;//是否需要报关
@property (nonatomic, strong) NSDate *customsIn;//报关时间
@property (nonatomic, strong) NSDate *cargoTakeTime;//提货时间
@end