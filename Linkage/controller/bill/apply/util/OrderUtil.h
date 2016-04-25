//
//  OrderUtil.h
//  Linkage
//
//  Created by lihaijian on 16/4/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGRestClient.h"
@class Order;
@class OrderModel;
@interface OrderUtil : NSObject

+(void)syncToServer:(Order *)order success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;

+(void)syncToDataBase:(Order *)order completion:(MRSaveCompletionHandler)completion;

+(Order *)modelFromXLFormValue:(NSDictionary *)formValues;

+(NSDictionary *)jsonFromModel:(Order *)order;

+(Order *)modelFromManagedObject:(OrderModel *)orderModel;

+(void)queryAllOrder:(void(^)(NSArray *orders))completion;

@end

@interface NSArray (OrderModel)

-(NSArray *)modelsFromManagedObject;
@end;