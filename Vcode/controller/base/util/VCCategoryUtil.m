//
//  VCCategoryUtil.m
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCategoryUtil.h"
#import "VCCategory.h"
#import "VCCategoryModel.h"

@implementation VCCategoryUtil
+(Class)modelClass{ return [VCCategory class]; }
+(Class)managedObjectClass{ return [VCCategoryModel class];}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    VCCategory *category = (VCCategory *)model;
    if (category.title) {
        VCCategoryModel *existModel = [self.managedObjectClass MR_findFirstByAttribute:@"title" withValue:category.title inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        VCCategoryModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:category insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
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
    NSError *error;
    NSURL *categoryUrl = [[NSBundle mainBundle] URLForResource:@"category" withExtension:@"plist"];
    NSArray *categoryList = [NSArray arrayWithContentsOfURL:categoryUrl];
    NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:categoryList error:&error];
    for (int i = 0; i < array.count; i++) {
        ((VCCategory *)[array objectAtIndex:i]).sort = @(i);
    }
    completion(array);
}

//数据库查询
+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion
{
    NSArray *managerObjects = [VCCategoryModel MR_findAllSortedBy:@"sort" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:managerObjects.count];
    for (NSManagedObject *manageObj in managerObjects) {
        id<MTLJSONSerializing> model = [self modelFromManagedObject:manageObj];
        [mutableArray addObject:model];
    }
    if (completion) {
        completion([mutableArray copy]);
    }
}

+(void)syncCategory:(void(^)(NSArray *models))completion
{
    @weakify(self)
    [self queryModelsFromServer:^(NSArray *models) {
        @strongify(self)
        for (id model in models) {
            [self syncToDataBase:model completion:nil];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
            completion(models);
        }];
    }];
}

+(NSArray *)queryAllCategoryTitles
{
    __block NSMutableArray *titles = [[NSMutableArray alloc]init];
    void(^addToList)(NSArray *models) = ^(NSArray *models) {
        for (VCCategory *model in models) {
            [titles addObject:model.title];
        }
    };
    [self queryModelsFromDataBase:^(NSArray *models) {
        if (models.count == 0) {
            [self syncCategory:^(NSArray *models) {
                addToList(models);
            }];
        }else{
            addToList(models);
        }
    }];
    return [titles copy];
}

+(NSArray *)queryAllCategories
{
    __block NSMutableArray *list = [[NSMutableArray alloc]init];
    void(^addToList)(NSArray *models) = ^(NSArray *models) {
        [list addObjectsFromArray:models];
    };
    [self queryModelsFromDataBase:^(NSArray *models) {
        if (models.count == 0) {
            [self syncCategory:^(NSArray *models) {
                addToList(models);
            }];
        }else{
            addToList(models);
        }
    }];
    return [list copy];
}

+(id)getModelByIndex:(NSInteger)index
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"sort", @(index)];
    VCCategoryModel *manageObj = [VCCategoryModel MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    id<MTLJSONSerializing> result = [self modelFromManagedObject:manageObj];
    return result;
}

@end
