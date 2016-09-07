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
@property (nonatomic, strong) NSNumber *cargoId;//货柜ID
@property (nonatomic, strong) NSNumber *cargoType;//货柜类型
@property (nonatomic, copy  ) NSString *cargoNo;//货柜号
@property (nonatomic, copy  ) NSString *cargoName;//货柜名
@property (nonatomic, strong) NSNumber *cargoCount;//货柜数量
+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName;
+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName count:(NSNumber *)cargoCount;
+(Cargo *)cargoWithType:(NSNumber *)type name:(NSString *)cargoName count:(NSNumber *)cargoCount cargoNo:(NSString *)cargoNo;
@end

@interface NSArray(CargoModel)
-(NSString *)cargosStringValue4ExportOrSelf;
-(NSString *)cargosStringValue4Import;
@end