//
//  OrderModel.h
//  Linkage
//
//  Created by Mac mini on 16/4/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
NS_ASSUME_NONNULL_BEGIN

@interface CargoModel : NSManagedObject
@property (nullable, nonatomic, retain) NSNumber *cargoCount;
@property (nullable, nonatomic, retain) NSNumber *cargoId;
@property (nullable, nonatomic, retain) NSString *cargoName;
@property (nullable, nonatomic, retain) NSManagedObject *order;
@end

@interface OrderModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *orderId;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *transporterId;
@property (nullable, nonatomic, retain) NSString *manufactureId;
@property (nullable, nonatomic, retain) NSString *manufactureContactName;
@property (nullable, nonatomic, retain) NSString *manufactureContactTel;
@property (nullable, nonatomic, retain) NSString *transporterContactName;
@property (nullable, nonatomic, retain) NSString *transporterContractTel;
@property (nullable, nonatomic, retain) NSString *takeAddress;
@property (nullable, nonatomic, retain) NSDate *takeTime;
@property (nullable, nonatomic, retain) NSString *deliveryAddress;
@property (nullable, nonatomic, retain) NSDate *deliverTime;
@property (nullable, nonatomic, retain) NSDate *cargosCentExpire;
@property (nullable, nonatomic, retain) NSString *memo;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSDate *updateTime;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSSet<CargoModel *> *cargos;
@end

@interface OrderModel (CoreDataGeneratedAccessors)
- (void)addCargosObject:(CargoModel *)value;
- (void)removeCargosObject:(CargoModel *)value;
- (void)addCargos:(NSSet<CargoModel *> *)values;
- (void)removeCargos:(NSSet<CargoModel *> *)values;
@end

@interface ImportOrderModel : OrderModel
@property (nullable, nonatomic, retain) NSString *billNo;
@property (nullable, nonatomic, retain) NSString *cargoNo;
@property (nullable, nonatomic, retain) NSString *customsHouseContact;
@property (nullable, nonatomic, retain) NSString *customsBroker;
@end

NS_ASSUME_NONNULL_END
