//
//  CargoModel.h
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <XLForm/XLForm.h>

@interface Cargo : MTLModel<XLFormOptionObject, MTLJSONSerializing>

@property (nonatomic, strong) XLFormOptionsObject *cargoType;
@property (nonatomic, copy) NSString *cargoCount;

+(Cargo *)cargoModelWithType:(XLFormOptionsObject *)cargoType cargoCount:(NSString *)cargoCount;
+(Cargo *)cargoModelWithValue:(id)value displayText:(NSString *)displayText cargoCount:(NSString *)cargoCount;
@end

@interface NSArray(CargoModel)
-(NSString *)cargosStringValue;
@end