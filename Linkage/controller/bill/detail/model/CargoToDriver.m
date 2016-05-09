//
//  CargoToDriver.m
//  Linkage
//
//  Created by Mac mini on 16/5/9.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CargoToDriver.h"
#import "Driver.h"
#import "Cargo.h"

@implementation CargoToDriver

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

- (instancetype)initWithDriver:(Driver *)driver cargo:(Cargo *)cargo
{
    self = [super init];
    if (self) {
        if (driver) {
            self.driverId = driver.driverId;
            self.driverName = driver.name;
            self.driverLicense = driver.license;
        }
        if (cargo) {
            self.cargoNo = cargo.cargoNo;
            self.cargoType = cargo.cargoType;
        }
    }
    return self;
}

@end
