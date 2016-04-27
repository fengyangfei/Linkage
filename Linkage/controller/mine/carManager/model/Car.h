//
//  Car.h
//  Linkage
//
//  Created by lihaijian on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"

@interface Car : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing,ModelHttpParameter>
@property (nonatomic,copy) NSString *carId;
@property (nonatomic,copy) NSString *license;//车牌号
@property (nonatomic,copy) NSString *engineNo;//发动机号
@property (nonatomic,copy) NSString *frameNo;//车架号
@property (nonatomic,strong) NSDate *applyDate;//上牌日期
@property (nonatomic,strong) NSDate *examineData;//年审日期
@property (nonatomic,strong) NSDate *maintainData;//二级维护月份
@property (nonatomic,strong) NSDate *trafficInsureData;//交强险日期
@property (nonatomic,strong) NSDate *businessInsureData;//商业险日期
@property (nonatomic,copy) NSString *insureCompany;//保险公司名称
@property (nonatomic,copy) NSString *memo;//备注
@property (nonatomic,copy) NSString *userId;
@end
