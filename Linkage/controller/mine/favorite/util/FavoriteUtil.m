//
//  FavoriteUtil.m
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FavoriteUtil.h"
#import "Favorite.h"
#import "LoginUser.h"
#import "FavoriteModel.h"

@implementation FavoriteUtil
+(Class)modelClass
{
    return [Favorite class];
}

+(Class)managedObjectClass
{
    return [FavoriteModel class];
}

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    NSDictionary *paramter = [self jsonFromModel:model];
    paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:[LoginUser shareInstance].baseHttpParameter];
    if (paramter) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:AddFavoriteUrl form:paramter success:success failure:failure];
    }
}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    Favorite *favorite = (Favorite *)model;
    if (favorite.companyId) {
        FavoriteModel *existModel = [FavoriteModel MR_findFirstByAttribute:@"companyId" withValue:favorite.companyId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        favorite.userId = [LoginUser shareInstance].cid;
        FavoriteModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:favorite insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (addModel && !error) {
            if (completion) {
                completion();
            }
        }else{
            NSLog(@"同步到数据库失败 - %@",error);
        }
    }
}

+(void)deleteFromServer:(id<MTLJSONSerializing,ModelHttpParameter>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure
{
    if (model.httpParameterForDetail) {
        [[YGRestClient sharedInstance] postForObjectWithUrl:DelFavoriteUrl form:model.httpParameterForDetail success:success failure:failure];
    }
}

+(void)deleteFromDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    Favorite *favorite = (Favorite *)model;
    if (favorite.companyId) {
        FavoriteModel *existModel = [FavoriteModel MR_findFirstByAttribute:@"companyId" withValue:favorite.companyId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        if (completion) {
            completion();
        }
    }
}

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:FavoritesUrl form:[LoginUser shareInstance].basePageHttpParameter success:^(id responseObject) {
        if (responseObject[@"companies"] && [responseObject[@"companies"] isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject[@"companies"] error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(array);
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
    NSArray *managerObjects = [FavoriteModel MR_findByAttribute:@"userId" withValue:[LoginUser shareInstance].cid andOrderBy:@"companyId" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:managerObjects.count];
    for (NSManagedObject *manageObj in managerObjects) {
        id<MTLJSONSerializing> model = [self modelFromManagedObject:manageObj];
        [mutableArray addObject:model];
    }
    if (completion) {
        completion([mutableArray copy]);
    }
}

@end
