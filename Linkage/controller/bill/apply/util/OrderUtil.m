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
    NSError *error;
    NSDictionary *paramter = [MTLJSONAdapter JSONDictionaryFromModel:order error:&error];
    if (!error) {
        if ([order isKindOfClass:[ImportOrder class]]) {
            [[YGRestClient sharedInstance] postWithUrl:Place4importUrl form:paramter success:success failure:failure];
        }else if([order isKindOfClass:[ExportOrder class]]){
            [[YGRestClient sharedInstance] postWithUrl:Place4exportUrl form:paramter success:success failure:failure];
        }else if([order isKindOfClass:[SelfOrder class]]){
            [[YGRestClient sharedInstance] postWithUrl:Place4selfUrl form:paramter success:success failure:failure];
        }
    }else{
        NSLog(@"同步到服务器失败 - %@",error);
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

+(Order *)modelFromXLFormValue:(NSDictionary *)formValues
{
    NSError *error;
    Order *order = [MTLJSONAdapter modelOfClass:[Order class] fromJSONDictionary:formValues error:&error];
    if (!error) {
        order.cargos = formValues[@"cargos"];
        order.companyId = ((Company *)formValues[@"company"]).companyId;
        order.userId = [LoginUser shareInstance].userId;
        if ([order isKindOfClass:[ExportOrder class]]) {
            ((ExportOrder *)order).soImages = formValues[@"soImages"];
        }
    }else{
        NSLog(@"表单转换成对象失败 - %@",error);
    }
    return order;
}

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

+(Order *)modelFromManagedObject:(OrderModel *)orderModel
{
    NSError *error;
    Order *order = [MTLManagedObjectAdapter modelOfClass:[Order class] fromManagedObject:orderModel error:&error];
    if (error) {
        NSLog(@"数据库对象转换对象失败 - %@",error);
    }
    return order;
}

@end
