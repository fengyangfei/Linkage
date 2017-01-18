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
    if (category.code) {
        VCCategoryModel *existModel = [self.managedObjectClass MR_findFirstByAttribute:@"code" withValue:category.code inContext:[NSManagedObjectContext MR_defaultContext]];
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

+(void)queryAllCategoryTitles:(void(^)(NSArray *titles))completion
{
    void(^addToList)(NSArray *models) = ^(NSArray *models) {
        NSMutableArray *titles = [[NSMutableArray alloc]init];
        for (VCCategory *model in models) {
            [titles addObject:model.title];
        }
        completion(titles);
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
}

+(void)queryAllCategories:(void(^)(NSArray *models))completion;
{
    void(^addToList)(NSArray *models) = ^(NSArray *models) {
        if(completion){
            completion(models);
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
}

+(void)getFavorCategories:(void(^)(NSArray *models))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"favor", @(YES)];
    [self queryModelsFromDataBase:predicate completion:completion];
}

+(void)getVisibleCategories:(void(^)(NSArray *models))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"visible", @(YES)];
    [self queryModelsFromDataBase:predicate completion:completion];
}

+(void)getHiddenCategories:(void(^)(NSArray *models))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"visible", @(NO)];
    [self queryModelsFromDataBase:predicate completion:completion];
}

+(void)getModelByIndex:(NSInteger)index completion:(void(^)(id<MTLJSONSerializing> model))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"sort", @(index)];
    [self queryModelFromDataBase:predicate completion:completion];
}

+(void)getModelByTitle:(NSString *)title completion:(void(^)(id<MTLJSONSerializing> model))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"title", title];
    [self queryModelFromDataBase:predicate completion:completion];
}

+(void)getModelByCode:(NSString *)code completion:(void(^)(id<MTLJSONSerializing> model))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"code", code];
    [self queryModelFromDataBase:predicate completion:completion];
}

+(void)queryModelFromDataBase:(NSPredicate *)predicate completion:(void(^)(id<MTLJSONSerializing> model))completion
{
    VCCategoryModel *manageObj = [VCCategoryModel MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    id<MTLJSONSerializing> result = [self modelFromManagedObject:manageObj];
    completion(result);
}

+(void)queryModelsFromDataBase:(NSPredicate *)predicate completion:(void(^)(NSArray *models))completion
{
    NSArray *managerObjects = [VCCategoryModel MR_findAllSortedBy:@"sort" ascending:YES withPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:managerObjects.count];
    for (NSManagedObject *manageObj in managerObjects) {
        id<MTLJSONSerializing> model = [self modelFromManagedObject:manageObj];
        [mutableArray addObject:model];
    }
    if (completion) {
        completion([mutableArray copy]);
    }
}

+(void)updateCategory:(NSString *)title sort:(NSInteger)sort visible:(BOOL)visible
{
    VCCategoryModel *existModel = [VCCategoryModel MR_findFirstByAttribute:@"title" withValue:title inContext:[NSManagedObjectContext MR_defaultContext]];
    if(!existModel){
        return;
    }
    existModel.sort = @(sort);
    existModel.visible = visible;
}

@end
