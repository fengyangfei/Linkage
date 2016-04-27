//
//  ModelOperation.h
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//
#import "YGRestClient.h"
@class MTLModel;
@protocol ModelOperation <NSObject>

@optional

+(void)syncToServer:(MTLModel *)model success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure;

+(void)syncToDataBase:(MTLModel *)model completion:(MRSaveCompletionHandler)completion;

+(MTLModel *)modelFromJson:(NSDictionary *)json;

+(MTLModel *)modelFromXLFormValue:(NSDictionary *)formValues;

+(MTLModel *)modelFromManagedObject:(NSManagedObject *)managedObject;

+(NSDictionary *)jsonFromModel:(id<MTLJSONSerializing>)model;

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion;

+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion;

+(void)queryModelsFromServer:(MTLModel *)model completion:(void(^)(MTLModel *result))completion;

@end