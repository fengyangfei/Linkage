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

@implementation VCRankUtil

+(Class)modelClass{ return [VCRank class]; }
+(Class)managedObjectClass{ return [VCRankModel class];}

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{
    NSDictionary *parameter = @{@"deviceCode":@"123123123"};
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
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
