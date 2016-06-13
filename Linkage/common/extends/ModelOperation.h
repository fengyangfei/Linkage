//
//  ModelOperation.h
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//
#import "YGRestClient.h"
#import <Mantle/MTLJSONAdapter.h>
@protocol ModelHttpParameter <NSObject>
@optional
-(NSDictionary *)httpParameterForDetail;
@end

@protocol ModelOperation <NSObject>
@optional
+(Class)modelClass;

+(Class)managedObjectClass;

+(id<MTLJSONSerializing>)modelFromJson:(NSDictionary *)json;

+(id<MTLJSONSerializing>)modelFromXLFormValue:(NSDictionary *)formValues;

+(id<MTLJSONSerializing>)modelFromManagedObject:(NSManagedObject *)managedObject;

+(NSDictionary *)jsonFromModel:(id<MTLJSONSerializing>)model;

+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion;

+(void)deleteFromServer:(id<MTLJSONSerializing,ModelHttpParameter>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;

+(void)deleteFromDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion;

+(void)truncateAll;

//服务端查询列表
+(void)queryModelsFromServer:(void(^)(NSArray *models))completion;

+(void)queryModelsFromServer:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion;

+(void)queryModelsFromServer:(NSDictionary *)parameter url:(NSString *)url completion:(void(^)(NSArray *models))completion;

//服务端查询详情
+(void)queryModelFromServer:(void(^)(id<MTLJSONSerializing> model))completion;

+(void)queryModelFromServer:(id<MTLJSONSerializing,ModelHttpParameter>)model completion:(void(^)(id<MTLJSONSerializing> result))completion;

+(void)queryModelFromServer:(NSDictionary *)parameter url:(NSString *)url completion:(void(^)(id<MTLJSONSerializing> model))completion;

//数据库查询
+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion;

+(void)queryModelsFromDataBase:(NSPredicate *)predicate completion:(void(^)(NSArray *models))completion;

@end