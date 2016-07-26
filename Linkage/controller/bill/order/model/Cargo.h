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
@property (nonatomic, strong) NSNumber *cargoType;
@property (nonatomic, copy  ) NSString *cargoNo;
@property (nonatomic, copy  ) NSString *cargoName;
@property (nonatomic, strong) NSNumber *cargoCount;
+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName;
+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName count:(NSNumber *)cargoCount;
+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName count:(NSNumber *)cargoCount cargoNo:(NSString *)cargoNo;
@end

@interface NSArray(CargoModel)
-(NSString *)cargosStringValue4ExportOrSelf;
-(NSString *)cargosStringValue4Import;
@end