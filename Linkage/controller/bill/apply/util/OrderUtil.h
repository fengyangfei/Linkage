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

+(Order *)modelFromManagedObject:(OrderModel *)orderModel;

+(NSDictionary *)jsonFromModel:(Order *)order;

+(void)queryOrdersFromServer:(void(^)(NSArray *orders))completion;

+(void)queryOrdersFromDataBase:(void(^)(NSArray *orders))completion;

+(void)queryOrderFromServer:(Order *)order completion:(void(^)(Order *result))completion;
@end

@interface NSArray (OrderModel)

-(NSArray *)modelsFromManagedObject;
@end;