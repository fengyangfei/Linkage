//
//  OrderUtil.h
//  Linkage
//
//  Created by lihaijian on 16/4/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGRestClient.h"
#import "ModelUtil.h"
@class Order;
@class OrderModel;
@interface OrderUtil : ModelUtil
+(void)truncateTodoOrders;
+(void)truncateDoneOrders;
+(void)acceptOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
+(void)confirmOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
+(void)rejectOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
+(void)cancelOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
+(void)dispatchTask:(NSDictionary *)parameter success:(void(^)(NSArray *tasks))success failure:(void(^)(NSError *error))failure;
@end

@interface NSArray (OrderModel)

-(NSArray *)modelsFromManagedObject;
@end;