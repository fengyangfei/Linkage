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
@end

@interface NSArray (OrderModel)

-(NSArray *)modelsFromManagedObject;
@end;