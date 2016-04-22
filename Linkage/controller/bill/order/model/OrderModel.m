//
//  OrderModel.m
//  Linkage
//
//  Created by Mac mini on 16/4/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "OrderModel.h"

@implementation CargoModel : NSManagedObject
@dynamic cargoCount;
@dynamic cargoId;
@dynamic cargoName;
@dynamic order;
@end

@implementation OrderModel
@dynamic orderId;
@dynamic type;
@dynamic transporterId;
@dynamic manufactureId;
@dynamic manufactureContactName;
@dynamic manufactureContactTel;
@dynamic transporterContactName;
@dynamic transporterContractTel;
@dynamic takeAddress;
@dynamic takeTime;
@dynamic deliveryAddress;
@dynamic deliverTime;
@dynamic cargosCentExpire;
@dynamic memo;
@dynamic createTime;
@dynamic updateTime;
@dynamic status;
@dynamic userId;
@dynamic cargos;
@end

@implementation ImportOrderModel
@dynamic billNo;
@dynamic cargoNo;
@dynamic customsHouseContact;
@dynamic customsBroker;
@end
