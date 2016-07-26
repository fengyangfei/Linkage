//
//  OrderUtil.m
//  Linkage
//
//  Created by lihaijian on 16/4/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "OrderUtil.h"
#import "Order.h"
#import "OrderModel.h"
#import "Cargo.h"
#import "Company.h"
#import "SOImage.h"
#import "LoginUser.h"
#import "Task.h"
#import "MTLManagedObjectAdapter.h"
#import <Mantle/Mantle.h>

@implementation OrderUtil

+(Class)modelClass
{
    return [Order class];
}

+(Class)managedObjectClass
{
    return [OrderModel class];
}

//json转换成对象
+(id<MTLJSONSerializing>)modelFromJson:(NSDictionary *)json
{
    NSError *error;
    Order *order = [MTLJSONAdapter modelOfClass:[Order class] fromJSONDictionary:json error:&error];
    if (!error) {
        if (json[@"cargos"] && [json[@"cargos"] isKindOfClass:[NSArray class]]) {
            NSArray *cargos = [MTLJSONAdapter modelsOfClass:[Cargo class] fromJSONArray:json[@"cargos"] error:&error];
            order.cargos = cargos;
        }
        order.userId = [LoginUser shareInstance].cid;
    }else{
        NSLog(@"JSON转换成对象失败 - %@",error);
    }
    return order;
}

//form转换成对象
+(id<MTLJSONSerializing>)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSError *error;
    Order *order = [MTLJSONAdapter modelOfClass:[Order class] fromJSONDictionary:formValues error:&error];
    if (!error) {
        order.userId = [LoginUser shareInstance].cid;
        order.updateTime = [NSDate date];
        order.cargos = formValues[@"cargos"];
        if (formValues[@"company"] && [formValues[@"company"] isKindOfClass:[Company class]]) {
            Company *company = (Company *)formValues[@"company"];
            order.companyId = company.companyId;
            order.companyName = company.companyName;
        }
        if ([order isKindOfClass:[ExportOrder class]]) {
            ((ExportOrder *)order).soImages = formValues[@"soImages"];
            ((ExportOrder *)order).port = [formValues[@"port_option"] formValue];
        }else if ([order isKindOfClass:[ImportOrder class]]) {
            order.takeAddress = [formValues[@"take_address_option"] formValue];
        }
    }else{
        NSLog(@"表单转换成对象失败 - %@",error);
    }
    return order;
}

//数据库对象转换成普通对象
+(id<MTLJSONSerializing>)modelFromManagedObject:(NSManagedObject *)managedObject
{
    NSError *error;
    Order *order;
    if ([managedObject isKindOfClass:[ImportOrderModel class]]) {
        order = [MTLManagedObjectAdapter modelOfClass:[ImportOrder class] fromManagedObject:managedObject error:&error];
    }else if([managedObject isKindOfClass:[ExportOrderModel class]]) {
        order = [MTLManagedObjectAdapter modelOfClass:[ExportOrder class] fromManagedObject:managedObject error:&error];
    }else if([managedObject isKindOfClass:[SelfOrderModel class]]) {
        order = [MTLManagedObjectAdapter modelOfClass:[SelfOrder class] fromManagedObject:managedObject error:&error];
    }else{
        order = [MTLManagedObjectAdapter modelOfClass:[Order class] fromManagedObject:managedObject error:&error];
    }
    if (error) {
        NSLog(@"数据库对象转换对象失败 - %@",error);
    }
    if (order) {
        order.objStatus = Persistent;
    }
    return order;
}

//转换成json
+(NSDictionary *)jsonFromModel:(id<MTLJSONSerializing>)model
{
    NSError *error;
    Order *order = (Order *)model;
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:order error:&error];
    if (error) {
        NSLog(@"对象转换字典失败 - %@",error);
    }
    if (dic) {
        NSMutableDictionary *mutableDic = [dic mutableCopy];
        mutableDic[@"cid"] = [LoginUser shareInstance].cid;
        mutableDic[@"token"] = [LoginUser shareInstance].token;
        mutableDic[@"company_id"] = order.companyId;
        mutableDic[@"cargo"] = [order.cargos cargosStringValue];
        if ([order isKindOfClass:[ExportOrder class]]) {
            mutableDic[@"so"] = @"so";
            mutableDic[@"so_images"] = [((ExportOrder *)order).soImages soImageStringValue];
        }
        return [mutableDic copy];
    }else{
        return nil;
    }
}

//同步到服务端
+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    Order *order = (Order *)model;
    NSDictionary *paramter = [self jsonFromModel:model];
    if (paramter && StringIsNotEmpty(order.orderId)) {
        //修改接口(只有被拒绝的订单才能修改，其它状态订单都不能被修改)
        NSDictionary *extendKey = @{
                                    @"rejected_order_id":order.orderId,
                                    @"rejected_order_status":@(OrderStatusDenied)
                                    };
        paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:extendKey];
        if (order.type == OrderTypeImport || [model isKindOfClass:[ImportOrder class]]) {
            [[YGRestClient sharedInstance] postForObjectWithUrl:Mod4importUrl form:paramter success:success failure:failure];
        }else if(order.type == OrderTypeExport || [model isKindOfClass:[ExportOrder class]]){
            [[YGRestClient sharedInstance] postForObjectWithUrl:Mod4exportUrl form:paramter success:success failure:failure];
        }else if(order.type == OrderTypeSelf || [model isKindOfClass:[SelfOrder class]]){
            [[YGRestClient sharedInstance] postForObjectWithUrl:Mod4selfUrl form:paramter success:success failure:failure];
        }
    }else if(paramter){
        //新增接口
        if (order.type == OrderTypeImport || [model isKindOfClass:[ImportOrder class]]) {
            [[YGRestClient sharedInstance] postForObjectWithUrl:Place4importUrl form:paramter success:success failure:failure];
        }else if(order.type == OrderTypeExport || [model isKindOfClass:[ExportOrder class]]){
            [[YGRestClient sharedInstance] postForObjectWithUrl:Place4exportUrl form:paramter success:success failure:failure];
        }else if(order.type == OrderTypeSelf || [model isKindOfClass:[SelfOrder class]]){
            [[YGRestClient sharedInstance] postForObjectWithUrl:Place4selfUrl form:paramter success:success failure:failure];
        }
    }
}

//同步到数据库
+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    Order *order = (Order *)model;
    if (order.orderId) {
        OrderModel *existModel = [OrderModel MR_findFirstByAttribute:@"orderId" withValue:order.orderId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        order.userId = [LoginUser shareInstance].cid;
        OrderModel *orderModel = [MTLManagedObjectAdapter managedObjectFromModel:order insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (orderModel && !error) {
            if (completion) {
                completion();
            }
        }else{
            NSLog(@"同步到数据库失败 - %@",error);
        }
    }
}

//删除未完成订单
+(void)truncateTodoOrders
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ AND (status == %@ OR status == %@)", [LoginUser shareInstance].cid, @(OrderStatusPending), @(OrderStatusExecuting)];
    NSArray *objectsToDelete = [OrderModel MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    for (NSManagedObject *objectToDelete in objectsToDelete)
    {
        [objectToDelete MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    }
}

//删除已完成订单
+(void)truncateDoneOrders
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ AND (status == %@ OR status == %@ OR status == %@)", [LoginUser shareInstance].cid, @(OrderStatusCompletion), @(OrderStatusDenied), @(OrderStatusCancelled)];
    NSArray *objectsToDelete = [OrderModel MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    for (NSManagedObject *objectToDelete in objectsToDelete)
    {
        [objectToDelete MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    }
}

//删掉数据库对象
+(void)deleteFromDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    Order *order = (Order *)model;
    if (order.orderId) {
        OrderModel *model = [OrderModel MR_findFirstByAttribute:@"orderId" withValue:order.orderId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (model) {
            [model MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        if (completion) {
            completion();
        }
    }
}

//服务端查询
+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{
    NSDictionary *parameter = @{
                               @"type":@(-1),
                               @"status":@(0),
                               @"pagination":@(0),
                               @"offset":@(0),
                               @"size":@(100)
                               };
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [self queryModelsFromServer:parameter completion:completion];
}

//服务端查询
+(void)queryModelsFromServer:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion
{
    [self queryModelsFromServer:parameter url:ListByStatusUrl completion:completion];
}

//服务端查询
+(void)queryModelsFromServer:(NSDictionary *)parameter url:(NSString *)url completion:(void(^)(NSArray *models))completion
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:url form:parameter success:^(id responseObject) {
        if (responseObject[@"orders"] && [responseObject[@"orders"] isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[Order class] fromJSONArray:responseObject[@"orders"] error:&error];
            if (completion && !error) {
                completion(array);
            }else if (error){
                NSLog(@"订单列表-json数组转对象数组失败 - %@",error);
            }
        }else{
            completion(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//数据库查询
+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"userId", [LoginUser shareInstance].cid];
    [self queryModelsFromDataBase:predicate completion:completion];
}

//数据库查询
+(void)queryModelsFromDataBase:(NSPredicate *)predicate completion:(void(^)(NSArray *models))completion
{
    NSArray *orderModelArray = [OrderModel MR_findAllSortedBy:@"updateTime" ascending:NO withPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    NSArray *orders = [orderModelArray modelsFromManagedObject];
    orders = [orders sortedArrayUsingComparator:^NSComparisonResult(Order *obj1, Order *obj2) {
        if (obj1.updateTime && obj2.updateTime) {
            return [obj2.updateTime compare:obj1.updateTime];
        }else{
            return NSOrderedDescending;
        }
    }];
    if (completion) {
        completion(orders);
    }
}

//服务端查询详情
+(void)queryModelFromServer:(id<MTLJSONSerializing,ModelHttpParameter>)model completion:(void(^)(id<MTLJSONSerializing> result))completion failure:(void (^)(NSError *))failure
{
    Order *order = (Order *)model;
    NSDictionary *paramter = @{@"order_id":order.orderId};
    paramter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:paramter];
    Order *(^mergeOrder)(id responseObject) = ^(id responseObject) {
        long long updateTime = [[NSNumber numberWithDouble:[order.updateTime timeIntervalSince1970]] longLongValue];
        long long createTime = [[NSNumber numberWithDouble:[order.createTime timeIntervalSince1970]] longLongValue];
        NSDictionary *mergeResponse = @{
                                        @"order_id":order.orderId,
                                        @"type":@(order.type),
                                        @"status":@(order.status),
                                        @"update_time":@(updateTime),
                                        @"create_time":@(createTime)
                                        };
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            mergeResponse = [responseObject mtl_dictionaryByAddingEntriesFromDictionary:mergeResponse];
        }
        Order *result = (Order *)[OrderUtil modelFromJson:mergeResponse];
        return result;
    };
    if (order.type == OrderTypeImport || [order isKindOfClass:[ImportOrder class]]) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:Detail4importUrl form:paramter success:^(id responseObject) {
            Order *result = mergeOrder(responseObject);
            if (completion) {
                completion(result);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }else if(order.type == OrderTypeExport || [order isKindOfClass:[ExportOrder class]]){
        [[YGRestClient sharedInstance] postForObjectWithUrl:Detail4exportUrl form:paramter success:^(id responseObject) {
            Order *result = mergeOrder(responseObject);
            if (completion) {
                completion(result);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }else if(order.type == OrderTypeSelf || [order isKindOfClass:[SelfOrder class]]){
        [[YGRestClient sharedInstance] postForObjectWithUrl:Detail4selfUrl form:paramter success:^(id responseObject) {
            Order *result = mergeOrder(responseObject);
            if (completion) {
                completion(result);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

//接单
+(void)acceptOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:AcceptOrderUrl form:model.httpParameterForDetail success:success failure:failure];
}

//结单
+(void)confirmOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:ConfirmOrderUrl form:model.httpParameterForDetail success:success failure:failure];
}

//拒绝
+(void)rejectOrder:(Order *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:RejectOrderUrl form:model.httpParameterForDetail success:success failure:failure];
}

+(void)dispatchTask:(NSDictionary *)parameter success:(void(^)(NSArray *tasks))success failure:(void(^)(NSError *error))failure
{

    [[YGRestClient sharedInstance] postForObjectWithUrl:DispatchUrl form:parameter success:^(id responseObject) {
        if (responseObject[@"task"] && [responseObject[@"task"] isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *tasks = [MTLJSONAdapter modelsOfClass:[Task class] fromJSONArray:responseObject[@"task"] error:&error];
            if (error){
                NSLog(@"任务列表-json数组转对象数组失败 - %@",error);
            }else{
                if (success) {
                    success(tasks);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

@implementation NSArray (OrderModel)
//对象转换
-(NSArray *)modelsFromManagedObject
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:self.count];
    for (OrderModel *manageObj in self) {
        Order *order = (Order *)[OrderUtil modelFromManagedObject:manageObj];
        if (order) {
            [mutableArray addObject:order];
        }
    }
    return [mutableArray copy];
}

@end
