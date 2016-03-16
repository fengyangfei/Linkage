//
//  CargoModel.h
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XLForm/XLForm.h>

@interface CargoModel : NSObject<XLFormOptionObject>

@property (nonatomic, strong) XLFormOptionsObject *cargoType;
@property (nonatomic, copy) NSString *cargoCount;

+(CargoModel *)cargoModelWithType:(XLFormOptionsObject *)cargoType cargoCount:(NSString *)cargoCount;
@end