//
//  MessageUtil.m
//  Linkage
//
//  Created by Mac mini on 16/5/3.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MessageUtil.h"
#import "Message.h"
#import "MessageModel.h"
#import "LoginUser.h"

@implementation MessageUtil

+(Class)modelClass
{
    return [Message class];
}

+(Class)managedObjectClass
{
    return [MessageModel class];
}

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    Message *message = (Message *)model;
    if (message.messageId) {
        MessageModel *existModel = [self.managedObjectClass MR_findFirstByAttribute:@"messageId" withValue:message.messageId inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        message.userId = [LoginUser shareInstance].cid;
        MessageModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:message insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
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

+(void)queryModelsFromServer:(void(^)(NSArray *models))completion
{
    [[YGRestClient sharedInstance] postForObjectWithUrl:MessagesUrl form:[LoginUser shareInstance].basePageHttpParameter success:^(id responseObject) {
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

//查询详情
+(void)queryModelFromServer:(id<MTLJSONSerializing,ModelHttpParameter>)model completion:(void(^)(id<MTLJSONSerializing> result))completion
{
    Message *message = (Message *)model;
    NSDictionary *keys = @{
                           @"message_id":message.messageId
                           };
    NSDictionary *paramter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:keys];
    Message *(^mergeMessage)(id responseObject) = ^(id responseObject) {
        Message *result = (Message *)[MessageUtil modelFromJson:responseObject];
        [result mergeValueForKey:@"messageId" fromModel:message];
        return result;
    };
    [[YGRestClient sharedInstance] postForObjectWithUrl:MessageDetailUrl form:paramter success:^(id responseObject) {
        Message *result = mergeMessage(responseObject);
        if (completion) {
            completion(result);
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
