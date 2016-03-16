//
//  CargoModel.m
//  XLForm
//
//  Created by Mac mini on 16/3/16.
//  Copyright © 2016年 Xmartlabs. All rights reserved.
//

#import "CargoModel.h"

@implementation CargoModel

+(CargoModel *)cargoModelWithType:(XLFormOptionsObject *)cargoType cargoCount:(NSString *)cargoCount
{
    CargoModel *obj = [[CargoModel alloc]init];
    obj.cargoType = cargoType;
    obj.cargoCount = cargoCount;
    return obj;
}

#pragma mark - XLFormOptionObject

-(NSString *)formDisplayText
{
    return self.cargoType.formDisplayText;
}

-(id)formValue
{
    return self.cargoType.formValue;
}

@end
