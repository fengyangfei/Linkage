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

@end
