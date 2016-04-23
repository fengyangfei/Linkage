//
//  CargoModel.h
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <XLForm/XLForm.h>
#import "MTLManagedObjectAdapter.h"
@class OrderModel;
@interface Cargo : MTLModel<XLFormOptionObject, MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSNumber *cargoId;
@property (nonatomic, copy) NSString *cargoName;
@property (nonatomic, strong) NSNumber *cargoCount;

+(Cargo *)cargoWithId:(NSNumber *)cargoId name:(NSString *)cargoName count:(NSNumber *)cargoCount;
@end

@interface NSArray(CargoModel)
-(NSString *)cargosStringValue;
@end