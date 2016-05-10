//
//  OrderUtil.h
//  Linkage
//
//  Created by lihaijian on 16/4/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGRestClient.h"
#import "ModelOperation.h"
@class Order;
@class OrderModel;
@interface OrderUtil : NSObject<ModelOperation>
+(void)acceptOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
+(void)confirmOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
+(void)rejectOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;
@end

@interface NSArray (OrderModel)

-(NSArray *)modelsFromManagedObject;
@end;