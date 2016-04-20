//
//  Company.h
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"

@interface Company : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *contactor;
@property (nonatomic,copy) NSString *contactorPhone;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *fax;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *phone1;
@property (nonatomic,copy) NSString *phone2;
@property (nonatomic,copy) NSString *phone3;
@property (nonatomic,copy) NSString *phone4;
@property (nonatomic,strong) NSArray *companyImages;
@property (nonatomic,strong) NSArray *customerPhones;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,strong) NSNumber *orderNum;//订单数量
@property (nonatomic,strong) NSNumber *score;//分值
-(BOOL)save;
+(Company *)shareInstance;
@end

@interface Car : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, strong) Company *company;
@property (nonatomic, copy) NSString *license;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *memo;
@end