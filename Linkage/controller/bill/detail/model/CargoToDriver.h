//
//  CargoToDriver.h
//  Linkage
//
//  Created by Mac mini on 16/5/9.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
@class Driver;
@class Cargo;
@interface CargoToDriver : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *driverId;
@property (nonatomic,copy) NSString *driverName;
@property (nonatomic,copy) NSString *driverLicense;
@property (nonatomic,copy) NSString *cargoNo;
@property (nonatomic,strong) NSNumber *cargoType;
@property (nonatomic,strong) NSNumber *status;

- (instancetype)initWithDriver:(Driver *)driver cargo:(Cargo *)cargo;
@end