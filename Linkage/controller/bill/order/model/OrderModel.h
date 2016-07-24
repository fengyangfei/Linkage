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
@property (nullable, nonatomic, retain) NSNumber *cargoType;
@property (nullable, nonatomic, retain) NSString *cargoNo;
@property (nullable, nonatomic, retain) NSString *cargoName;
@end

@interface SOImageModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *imageName;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSDate   *createDate;
@end

@interface CommentModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *commentId;
@property (nullable, nonatomic, retain) NSNumber *score;
@end

@interface OrderModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *orderId;
@property (nullable, nonatomic, retain) NSString *companyId;
@property (nullable, nonatomic, retain) NSString *userId;
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
@property (nullable, nonatomic, retain) NSDate *cargosRentExpire;
@property (nullable, nonatomic, retain) NSString *memo;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSDate *updateTime;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *isTransferPort;
@property (nullable, nonatomic, retain) NSSet<CargoModel *> *cargos;
@property (nullable, nonatomic, retain) CommentModel *comments;
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
@property (nullable, nonatomic, retain) NSString *cargoCompany;
@end

@interface ExportOrderModel : OrderModel
@property (nullable, nonatomic, retain) NSString *so;
@property (nullable, nonatomic, retain) NSDate *customsIn;
@property (nullable, nonatomic, retain) NSString *shipCompany;
@property (nullable, nonatomic, retain) NSString *shipName;
@property (nullable, nonatomic, retain) NSString *shipScheduleNo;
@property (nullable, nonatomic, retain) NSNumber *isBookCargo;
@property (nullable, nonatomic, retain) NSString *port;
@property (nullable, nonatomic, retain) NSSet<SOImageModel *> *soImages;
@end

@interface ExportOrderModel (CoreDataGeneratedAccessors)
- (void)addSoImagesObject:(SOImageModel *)value;
- (void)removeSoImagesObject:(SOImageModel *)value;
- (void)addSoImages:(NSSet<SOImageModel *> *)values;
- (void)removeSoImages:(NSSet<SOImageModel *> *)values;
@end

@interface SelfOrderModel : OrderModel
@property (nullable, nonatomic, retain) NSNumber *isCustomsDeclare;
@property (nullable, nonatomic, retain) NSDate *customsIn;
@property (nullable, nonatomic, retain) NSDate *cargoTakeTime;
@end

NS_ASSUME_NONNULL_END
