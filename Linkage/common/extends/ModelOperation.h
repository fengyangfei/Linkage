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
-(NSDictionary *)httpParameterForList;
-(NSDictionary *)httpParameterForDetail;
@end

@protocol ModelOperation <NSObject>
@optional
+(void)syncToServer:(id<MTLJSONSerializing>)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion;

+(id<MTLJSONSerializing>)modelFromJson:(NSDictionary *)json;

+(id<MTLJSONSerializing>)modelFromXLFormValue:(NSDictionary *)formValues;

+(id<MTLJSONSerializing>)modelFromManagedObject:(NSManagedObject *)managedObject;

+(NSDictionary *)jsonFromModel:(id<MTLJSONSerializing>)model;

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion;

+(void)queryModelsFromServerWithModel:(id<ModelHttpParameter>)parameter completion:(void(^)(NSArray *models))completion;

+(void)queryModelFromServer:(id)model completion:(void(^)(id<MTLJSONSerializing> result))completion;

+(void)queryModelFromServerWithModel:(id<ModelHttpParameter>)model completion:(void(^)(id<MTLJSONSerializing> result))completion;

+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion;

@end