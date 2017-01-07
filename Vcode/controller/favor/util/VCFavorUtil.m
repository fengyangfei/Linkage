//
//  VCFavorUtil.m
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorUtil.h"
#import "VCFavor.h"
#import "VCFavorModel.h"

@implementation VCFavorUtil
+(Class)modelClass{ return [VCFavor class]; }
+(Class)managedObjectClass{ return [VCFavorModel class];}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    VCFavor *favor = (VCFavor *)model;
    if (favor.title) {
        VCFavorModel *existModel = [self.managedObjectClass MR_findFirstByAttribute:@"title" withValue:favor.title inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        VCFavorModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:favor insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (addModel && !error) {
            if (completion) {
                completion();
            }
        }else{
            NSLog(@"同步到数据库失败 - %@",error);
        }
    }
}

//数据库查询
+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion
{
    NSArray *managerObjects = [VCFavorModel MR_findAllSortedBy:@"createdDate" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]];
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
