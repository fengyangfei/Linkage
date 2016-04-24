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
#import "MTLManagedObjectAdapter.h"
#import <Mantle/Mantle.h>

@implementation OrderUtil

//同步到服务端
+(void)syncToServer:(Order *)order success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    NSDictionary *paramter = [self jsonFromModel:order];
    if (paramter) {
        if ([order isKindOfClass:[ImportOrder class]]) {
            [[YGRestClient sharedInstance] postForObjectWithUrl:Place4importUrl json:paramter success:success failure:failure];
        }else if([order isKindOfClass:[ExportOrder class]]){
            [[YGRestClient sharedInstance] postForObjectWithUrl:Place4exportUrl json:paramter success:success failure:failure];
        }else if([order isKindOfClass:[SelfOrder class]]){
            [[YGRestClient sharedInstance] postForObjectWithUrl:Place4selfUrl json:paramter success:success failure:failure];
        }
    }
}

//同步到数据库
+(void)syncToDataBase:(Order *)order completion:(MRSaveCompletionHandler)completion;
{
    NSError *error;
    OrderModel *orderModel = [MTLManagedObjectAdapter managedObjectFromModel:order insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
    if (orderModel && !error) {
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:completion];
    }else{
        NSLog(@"同步到数据库失败 - %@",error);
    }
}

//form转换成对象
+(Order *)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSError *error;
    Order *order = [MTLJSONAdapter modelOfClass:[Order class] fromJSONDictionary:formValues error:&error];
    if (!error) {
        order.cargos = formValues[@"cargos"];
        if (formValues[@"company"] && [formValues[@"company"] isKindOfClass:[Company class]]) {
            order.companyId = ((Company *)formValues[@"company"]).companyId;
        }
        order.userId = [LoginUser shareInstance].userId;
        if ([order isKindOfClass:[ExportOrder class]]) {
            ((ExportOrder *)order).soImages = formValues[@"soImages"];
        }
    }else{
        NSLog(@"表单转换成对象失败 - %@",error);
    }
    return order;
}

//转换成json
+(NSDictionary *)jsonFromModel:(Order *)order
{
    NSError *error;
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

//数据库对象转换成普通对象
+(Order *)modelFromManagedObject:(OrderModel *)orderModel
{
    NSError *error;
    Order *order = [MTLManagedObjectAdapter modelOfClass:[Order class] fromManagedObject:orderModel error:&error];
    if (error) {
        NSLog(@"数据库对象转换对象失败 - %@",error);
    }
    return order;
}

+(void)queryAllOrder:(void(^)(NSArray *orders))completion
{
    NSDictionary *paramter = @{
                               @"cid":[LoginUser shareInstance].cid,
                               @"token":[LoginUser shareInstance].token,
                               @"type":@(-1),
                               @"status":@(0),
                               @"pagination":@(0),
                               @"offset":@(0),
                               @"size":@(100)
                               };
    [[YGRestClient sharedInstance] postForObjectWithUrl:ListByStatusUrl form:paramter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
