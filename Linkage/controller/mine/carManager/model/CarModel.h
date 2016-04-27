//
//  CarModel.h
//  Linkage
//
//  Created by lihaijian on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *carId;
@property (nullable, nonatomic, retain) NSString *license;
@property (nullable, nonatomic, retain) NSString *engineNo;
@property (nullable, nonatomic, retain) NSString *frameNo;
@property (nullable, nonatomic, retain) NSDate *applyDate;
@property (nullable, nonatomic, retain) NSDate *examineData;
@property (nullable, nonatomic, retain) NSDate *maintainData;
@property (nullable, nonatomic, retain) NSDate *trafficInsureData;
@property (nullable, nonatomic, retain) NSDate *businessInsureData;
@property (nullable, nonatomic, retain) NSString *insureCompany;
@property (nullable, nonatomic, retain) NSString *memo;
@property (nullable, nonatomic, retain) NSString *userId;
@end

NS_ASSUME_NONNULL_END