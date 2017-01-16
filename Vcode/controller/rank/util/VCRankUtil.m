//
//  VCRankUtil.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCRankUtil.h"
#import "VCRank.h"
#import "VCRankModel.h"
#import "YGRestClient.h"
#import "VcodeUtil.h"

@implementation VCRankUtil

+(Class)modelClass{ return [VCRank class]; }
+(Class)managedObjectClass{ return [VCRankModel class];}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    VCRank *rank = (VCRank *)model;
    if (rank.gid) {
        VCRankModel *existModel = [self.managedObjectClass MR_findFirstByAttribute:@"gid" withValue:rank.gid inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        VCRankModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:rank insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (addModel && !error) {
            if (completion) {
                completion();
            }
        }else{
            NSLog(@"同步到数据库失败 - %@",error);
        }
    }
}

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{
    NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID]};

    [self queryGlobalRank:parameter completion:completion failure:nil];
}

//热门排行
+(void)queryHotRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:HotUrl form:parameter success:^(id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(array);
            }
        }else{
            completion(nil);
        }
    } failure:failure];
}

//推荐排行
+(void)queryRecommendRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:RecommendUrl form:parameter success:^(id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(array);
            }
        }else{
            completion(nil);
        }
    } failure:failure];
}

//全球排行
+(void)queryGlobalRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:GlobalRankUrl form:parameter success:^(id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(array);
            }
        }else{
            completion(nil);
        }
    } failure:failure];
}

//地区查询
+(void)queryLocalRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure
{
    //NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"countryCode":@"CN"};
    [[YGRestClient sharedInstance] postForObjectWithUrl:CountryRankUrl form:parameter success:^(id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(array);
            }
        }else{
            completion(nil);
        }
    } failure:failure];
}

//分类查询
+(void)queryCategoryRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure
{
    //NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID],@"categoryCode":@"CN",@"page":@"1",@"pageSize":10};
    [[YGRestClient sharedInstance] postForObjectWithUrl:CategoryRankUrl form:parameter success:^(id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(array);
            }
        }else{
            completion(nil);
        }
    } failure:failure];
}

//数据库查询
+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion
{
    NSArray *managerObjects = [VCRankModel MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
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
